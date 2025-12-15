<#
	Strawberry Perl の Unicode 対応実行ファイルをコンパイルするスクリプト
	runperl.c を Unicode エントリポイント (wmain) でコンパイルする。
	uperl.exeという名前で登録される。
#>

# Strawberry Perl のルートディレクトリを指定（デフォルト: C:\Strawberry）
$rootdir = "C:\Strawberry"

# パスの設定
$perl_lib_core = "$rootdir\perl\lib\CORE"
$perl_bin = "$rootdir\perl\bin"
$gcc_bin = "$rootdir\c\bin\gcc.exe"
$c_include = "$rootdir\c\include"

# Perl バージョンの libperl ファイル名を自動検出
$libperl = Get-ChildItem "$perl_bin\perl*.dll" | Select-Object -First 1
$libperl_name = $libperl.BaseName

# コンパイル実行
$cmd = "$gcc_bin -municode -I `"$perl_lib_core`" -I `"$c_include`" runperl.c -L`"$perl_lib_core`" -L`"$perl_bin`" -l$libperl_name -o uperl.exe"
Write-Host "実行コマンド: $cmd"
Invoke-Expression $cmd


if ($LASTEXITCODE -eq 0) {
    Write-Host "コンパイル完了: uperl.exe"
    
    # 元の perl.exe をバックアップ
    $perl_exe = "$perl_bin\perl.exe"
    $perl_backup = "$perl_bin\perl_original.exe"
    
    if (Test-Path $perl_exe) {
        if (-not (Test-Path $perl_backup)) {
            Copy-Item $perl_exe $perl_backup -Force
            Write-Host "元の perl.exe を perl_original.exe にバックアップしました"
        }
        
        # uperl.exe を perl.exe として配置
        Copy-Item uperl.exe $perl_exe -Force
        Write-Host "uperl.exe を perl.exe として配置しました"
    }
} else {
    Write-Host "コンパイルエラーが発生しました"
}


