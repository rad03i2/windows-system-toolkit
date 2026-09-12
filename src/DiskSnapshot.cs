using System;

namespace WindowsSystemToolkit;

public sealed record DiskSnapshot(
    string DriveName,
    long TotalBytes,
    long FreeBytes)
{
    public long UsedBytes => TotalBytes - FreeBytes;
    public double UsedPercent => TotalBytes == 0 ? 0 : UsedBytes * 100.0 / TotalBytes;

    public override string ToString()
        => $"{DriveName}: {UsedPercent:F1}% used, {FreeBytes / 1_073_741_824.0:F2} GB free";
}
