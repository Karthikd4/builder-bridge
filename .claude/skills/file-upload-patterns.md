# Skill: File Upload Patterns

File handling patterns for BuilderBridge — receipt photos, AOS documents, support attachments.

## Phase 1: Local File Storage

```dart
// Store files in app documents directory (private, not backed up to cloud)
Future<String> saveFile(Uint8List bytes, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final subdir = Directory('${dir.path}/documents');
  await subdir.create(recursive: true);
  final file = File('${subdir.path}/$filename');
  await file.writeAsBytes(bytes);
  return file.path;  // Store this path in SQLite documents.file_path
}

Future<File?> getFile(String path) async {
  final file = File(path);
  return await file.exists() ? file : null;
}
```

## Image Picker (Receipt Photos)

```dart
// lib/core/utils/image_picker_helper.dart
class ImagePickerHelper {
  static final _picker = ImagePicker();

  static Future<File?> pickFromCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: 1920,
    );
    return image != null ? File(image.path) : null;
  }

  static Future<File?> pickFromGallery() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 1920,
    );
    return image != null ? File(image.path) : null;
  }
}
```

## Document Picker (PDF, DOCX)

```dart
// For AOS documents
static Future<File?> pickDocument() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
    withData: false,
    withReadStream: true,
  );
  if (result == null || result.files.isEmpty) return null;
  final path = result.files.single.path;
  return path != null ? File(path) : null;
}
```

## Image Source Bottom Sheet

```dart
Future<File?> showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<File?>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () async {
              Navigator.pop(context, await ImagePickerHelper.pickFromCamera());
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () async {
              Navigator.pop(context, await ImagePickerHelper.pickFromGallery());
            },
          ),
        ],
      ),
    ),
  );
}
```

## Phase 2: S3 Upload Pattern

```dart
// Will replace local storage with S3 presigned URL flow:
// 1. GET /api/v1/uploads/presigned-url?filename=receipt.jpg
// 2. PUT directly to S3 presigned URL (no backend proxy)
// 3. POST /api/v1/receipts with { s3Key: "..." }

Future<String> uploadToS3(File file, String presignedUrl) async {
  final response = await Dio().put(
    presignedUrl,
    data: file.openRead(),
    options: Options(
      headers: {
        'Content-Type': lookupMimeType(file.path) ?? 'application/octet-stream',
        'Content-Length': await file.length(),
      },
    ),
  );
  if (response.statusCode != 200) throw const ServerException();
  return presignedUrl.split('?').first;  // Return clean S3 URL
}
```

## Rules
- Max file size: 10MB (validate before saving/uploading)
- Allowed types: PDF for documents, JPEG/PNG for receipts
- Never store files in external storage
- File paths in SQLite are absolute — handle app reinstall by checking existence before display
- Show upload progress for files > 1MB
