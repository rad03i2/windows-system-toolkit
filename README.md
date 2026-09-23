# Windows System Toolkit

A safe, practical PowerShell toolkit for inspecting Windows system information, storage usage, large files, and temporary-file cleanup candidates — without silently changing the machine.

> **English first · العربية أدناه**

## Overview
Windows System Toolkit turns common Windows diagnostics into a small reusable PowerShell module and CLI. It exists for users and developers who want repeatable local reports without installing a heavy monitoring suite.

## Key features
- System inventory: Windows version, architecture, computer model, CPU, RAM, boot time.
- Fixed-drive storage report with size, free/used bytes, and free-space percentage.
- Recursive large-file discovery with configurable threshold and result limit.
- Safe cleanup **preview** for old files in the current user's temporary directories.
- JSON report export for automation and support workflows.
- Human-readable tables or JSON CLI output.
- No telemetry, cloud account, API key, or administrator requirement for normal use.

## Preview
```powershell
PS> ./wst.ps1 storage
Drive FileSystem SizeBytes     FreeBytes     UsedBytes      FreePercent
----- ---------- ---------     ---------     ---------      -----------
C:    NTFS       ...           ...           ...            ...

PS> ./wst.ps1 large-files -Path "$HOME\Downloads" -MinimumSize 1GB -Top 10
```
Output depends on the actual machine; the repository does not ship fake system data. For screenshots, run the commands locally and redact usernames/paths before publishing captures.

## Requirements & installation
- Windows 10/11 or Windows Server with CIM/WMI available.
- Windows PowerShell 5.1 or PowerShell 7+.

```powershell
git clone https://github.com/rad03i2/windows-system-toolkit.git
cd windows-system-toolkit
./wst.ps1 system
```
No dependency installation is required.

## Usage
```powershell
# System inventory
./wst.ps1 system
./wst.ps1 system -Json

# Storage
./wst.ps1 storage

# Find large files
./wst.ps1 large-files -Path "C:\Users\Public" -MinimumSize 500MB -Top 20

# Preview old temporary files; this DOES NOT delete them
./wst.ps1 cleanup-preview -OlderThanDays 14

# Export system + storage report
./wst.ps1 export -Path ./reports/system.json

# Version / author
./wst.ps1 -Version
```

### PowerShell API
```powershell
Import-Module ./WindowsSystemToolkit.psm1
Get-WstSystemReport
Get-WstStorageReport
Get-WstLargeFile -Path $HOME -MinimumSize 1GB -Top 10
Get-WstCleanupCandidate -OlderThanDays 7
Export-WstReport -Path ./reports/system.json
```

## Configuration
The toolkit intentionally has no persistent configuration file. CLI parameters control thresholds and paths. Size values accept `B`, `KB`, `MB`, `GB`, or `TB` (for example `1.5GB`).

## Project structure
```text
WindowsSystemToolkit.psm1  Core module
wst.ps1                    CLI entry point
scripts/                    Small standalone legacy helpers
src/                        Existing C# model/reference code
tests/Toolkit.Tests.ps1     Dependency-free functional tests
.github/workflows/ci.yml    Windows syntax/test/smoke CI
SECURITY.md                 Security model
CONTRIBUTING.md             Contribution guide
```

## Testing
```powershell
pwsh -NoProfile -File ./tests/Toolkit.Tests.ps1
```
CI also parses every `.ps1`/`.psm1` file and runs a JSON CLI smoke test on `windows-latest`.

## Security & privacy
Commands run locally. Cleanup is preview-only: this project does not delete files. Exported reports may contain usernames, device model and storage metadata, so review them before sharing. See [SECURITY.md](SECURITY.md).

## Limitations
- Windows-only system/storage inventory because it uses Windows CIM classes.
- Large recursive scans can take time on large directory trees and silently skip inaccessible files.
- Cleanup candidates cover the current user's temporary locations only; they are suggestions, not proof that a file is safe to remove.
- This is not antivirus, SMART diagnostics, a performance profiler, or a replacement for backups.

## Optional roadmap
Possible future additions include signed releases, opt-in event-log summaries, and richer hardware health adapters. These are not implemented today.

## Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md). Keep default behavior non-destructive and include tests for behavioral changes.

## License
MIT — see [LICENSE](LICENSE).

## Author
**Radwan Abdulhadi Ahmed**  
**رضوان عبدالهادي أحمد**  
GitHub: **@rad03i2**

Portfolio: https://rdwan.dev · Project page: https://rdwan.dev/projects/07-windows-system-toolkit.html

---

# العربية

## نظرة عامة
**Windows System Toolkit** حزمة PowerShell محلية وآمنة لجمع معلومات ويندوز والتخزين، العثور على الملفات الكبيرة، ومعاينة ملفات مؤقتة قديمة يمكن مراجعتها للتنظيف. الهدف هو توفير تشخيصات قابلة للتكرار دون تثبيت منصة مراقبة ثقيلة ودون تغيير الجهاز بصمت.

## لماذا المشروع؟
المعلومات المطلوبة عند تشخيص جهاز ويندوز تكون موزعة بين عدة أوامر ونوافذ. يجمع المشروع الوظائف الأساسية في واجهة CLI ووحدة PowerShell قابلة لإعادة الاستخدام، مع دعم JSON للأتمتة.

## المزايا
- معلومات النظام: إصدار ويندوز، المعمارية، طراز الجهاز، المعالج، الذاكرة ووقت الإقلاع.
- تقرير الأقراص المحلية مع الحجم والمساحة الحرة والمستخدمة والنسبة الحرة.
- البحث التكراري عن الملفات الكبيرة مع حد حجم وعدد نتائج قابلين للتعديل.
- **معاينة فقط** للملفات القديمة داخل مجلدات Temp الخاصة بالمستخدم؛ لا يوجد حذف تلقائي.
- تصدير تقرير JSON للنظام والتخزين.
- إخراج جدولي للمستخدم أو JSON للسكربتات.
- لا Telemetry ولا حساب سحابي ولا API key.

## التثبيت والمتطلبات
يتطلب Windows 10/11 أو Windows Server مع CIM، وWindows PowerShell 5.1 أو PowerShell 7+.

```powershell
git clone https://github.com/rad03i2/windows-system-toolkit.git
cd windows-system-toolkit
./wst.ps1 system
```

## الاستخدام
```powershell
./wst.ps1 system -Json
./wst.ps1 storage
./wst.ps1 large-files -Path "$HOME\Downloads" -MinimumSize 1GB -Top 10
./wst.ps1 cleanup-preview -OlderThanDays 14
./wst.ps1 export -Path ./reports/system.json
```

ولاستخدام الوحدة مباشرة:
```powershell
Import-Module ./WindowsSystemToolkit.psm1
Get-WstSystemReport
Get-WstStorageReport
Get-WstLargeFile -Path $HOME -MinimumSize 500MB
```

## الإعداد
لا يوجد ملف إعداد دائم عمدًا. جميع الخيارات تمرر كوسائط CLI. وحدات الحجم المدعومة: `B` و`KB` و`MB` و`GB` و`TB`.

## بنية المشروع
الوحدة `WindowsSystemToolkit.psm1` تحتوي المنطق الأساسي، و`wst.ps1` واجهة الأوامر، و`tests/` للاختبارات، و`.github/workflows/ci.yml` للتحقق الآلي. مجلدا `scripts/` و`src/` يحتفظان بالأدوات المرجعية السابقة الموجودة في المشروع.

## الاختبارات
```powershell
pwsh -NoProfile -File ./tests/Toolkit.Tests.ps1
```
كما يتحقق CI من صياغة جميع ملفات PowerShell ويشغل اختبارًا فعليًا للـCLI على Windows.

## الأمان والخصوصية
كل العمليات محلية. أمر التنظيف يعرض مرشحين فقط ولا يحذف أي ملف. قد يحتوي التقرير المصدّر على اسم المستخدم وطراز الجهاز ومعلومات التخزين، لذلك راجعه قبل مشاركته. راجع [SECURITY.md](SECURITY.md).

## القيود
المعلومات الأساسية تعتمد على CIM الخاص بويندوز. البحث في شجرة ملفات كبيرة قد يكون بطيئًا ويتجاوز الملفات التي لا توجد صلاحية لقراءتها. مرشحو Temp اقتراحات للمراجعة فقط. المشروع ليس مضاد فيروسات ولا أداة SMART ولا بديلًا عن النسخ الاحتياطي.

## التطوير المستقبلي الاختياري
يمكن مستقبلًا إضافة إصدارات موقعة وملخصات اختيارية لسجل الأحداث ومحولات إضافية لصحة العتاد؛ هذه الميزات غير موجودة حاليًا.

## المساهمة
راجع [CONTRIBUTING.md](CONTRIBUTING.md). يجب أن يبقى السلوك الافتراضي غير تدميري وأن ترافق تغييرات السلوك اختبارات مناسبة.

## الترخيص
MIT — راجع [LICENSE](LICENSE).

## المؤلف
**Radwan Abdulhadi Ahmed**  
**رضوان عبدالهادي أحمد**  
GitHub: **@rad03i2**
