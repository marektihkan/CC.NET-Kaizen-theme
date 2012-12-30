@echo ::
@echo :: Creating Keizen theme package
@echo ::

echo -- Creating manifest
CCNet.Plugins.CreatePackage.exe "..\Source\Kaizen" Kaizen

@echo -- Creating zip package
7za.exe a -tzip KaizenTheme.zip "..\Source\Kaizen\*"
7za.exe u KaizenTheme.zip package.xml


@echo Package created.
pause