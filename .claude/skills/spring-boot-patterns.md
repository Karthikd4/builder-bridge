# Skill: Spring Boot Patterns

Spring Boot 3.x patterns for BuilderBridge Phase 2 backend.

## Module Structure

```
src/main/java/com/builderbridge/<module>/
├── controller/
│   └── UnitController.java          ← REST endpoints only, no business logic
├── service/
│   └── UnitService.java             ← Business logic
├── repository/
│   └── UnitRepository.java          ← Spring Data JPA interface
├── model/
│   └── Unit.java                    ← JPA entity
└── dto/
    ├── UnitResponse.java            ← API response
    └── CreateUnitRequest.java       ← API request
```

## Standard Controller

```java
@RestController
@RequestMapping("/api/v1/towers/{towerId}/units")
@RequiredArgsConstructor
@Validated
public class UnitController {

    private final UnitService unitService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<UnitResponse>>> getUnits(
            @PathVariable Long towerId,
            @RequestParam(required = false) UnitStatus status) {
        return ResponseEntity.ok(ApiResponse.success(unitService.getUnits(towerId, status)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<UnitResponse>> getUnit(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.success(unitService.getUnit(id)));
    }
}
```

## Standard API Response Wrapper

```java
public record ApiResponse<T>(T data, Object meta, String error) {
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(data, null, null);
    }
    public static <T> ApiResponse<T> error(String message) {
        return new ApiResponse<>(null, null, message);
    }
}
```

## JPA Entity Rules

```java
@Entity
@Table(name = "units")
@Data
@NoArgsConstructor
public class Unit {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "tower_id", nullable = false)
    private Long towerId;

    @Column(name = "unit_no", nullable = false)
    private String unitNo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private UnitStatus status = UnitStatus.AVAILABLE;

    @Column(name = "base_price_paise", nullable = false)
    private Long basePricePaise;  // Store as paise, never float

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;  // Soft delete
}
```

## Flyway Migration

```sql
-- src/main/resources/db/migration/V1__create_units_table.sql
CREATE TABLE units (
    id BIGSERIAL PRIMARY KEY,
    tower_id BIGINT NOT NULL REFERENCES towers(id),
    unit_no VARCHAR(20) NOT NULL,
    floor INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL,
    area_sqft DECIMAL(8,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    base_price_paise BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP
);

CREATE INDEX idx_units_tower_id ON units(tower_id);
CREATE INDEX idx_units_status ON units(status);
```

## JWT Security Config

```java
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtAuthFilter jwtAuthFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
            .csrf(AbstractHttpConfigurer::disable)
            .sessionManagement(s -> s.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(a -> a
                .requestMatchers("/api/v1/auth/**").permitAll()
                .anyRequest().authenticated())
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
            .build();
    }
}
```

## Rules
- Controllers: routing only — no business logic
- Services: business logic — no JPA/SQL
- Repositories: data access — Spring Data JPA only
- All money as `Long` (paise) — never `Float`/`Double`
- Soft deletes: set `deleted_at`, never `DELETE`
- All migrations in `db/migration/` with version prefix `V<n>__`
