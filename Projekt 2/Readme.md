# Setup
Nachdem das Produkt generiert wurde und sich in `src-gen` befindet,
ist die einfachste Methode das Programm auszuführen:
- Zunächst ein neues Projekt erstellen (`New` -> `Java Project`)
- JavaFX dem Buildpath des neuen Projektes hinzufügen
(Rechtsklick auf neues Projekt -> `Build Path` -> `Configure Build Path...` -> `Libraries` -> `Add External JARs...`,
dann `[Pfad zum JDK]\jre\lib\ext\jfxrt.jar` auswählen).
- Die generierte .java-Datei aus `src-gen/` des Ursprungsprungsprojektes in `src/` des neuen Projektes kopieren
- Jetzt kann die generierte Datei ausgeführt werden
