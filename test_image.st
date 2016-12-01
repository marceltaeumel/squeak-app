| monitor |
buildDir := Smalltalk at: 1.
smalltalkCIDir := Smalltalk at: 2.

monitor := [ [
  FileStream stdout nextPutAll: '.'.
  (Delay forMilliseconds: 5000) wait] repeat ] forkAt: 75.

"# Install Metacello/FileTree ================================================="

"Get the Metacello configuration (for Squeak users)"
Installer gemsource
    project: 'metacello';
    addPackage: 'ConfigurationOfMetacello';
    install.

"Bootstrap Metacello Preview, using mcz files (#'previewBootstrap' symbolic version"
((Smalltalk at: #ConfigurationOfMetacello) project 
  version: #'previewBootstrap') load.

"Load the Preview version of Metacello from GitHub"
"(Smalltalk at: #Metacello) new
  configuration: 'MetacelloPreview';
  version: #stable;
  repository: 'github://dalehenrich/metacello-work:configuration';
  load."

"Now load latest version of Metacello"
"(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  get.
(Smalltalk at: #Metacello) new
  baseline: 'Metacello';
  repository: 'github://dalehenrich/metacello-work:master/repository';
  load: #('Cypress')."

[ Metacello new
  baseline: 'SmalltalkCI';
  repository: 'filetree://', smalltalkCIDir , '/repository")';
  onConflict: [:ex | ex pass];
  load ] on: Warning do: [:w | w resume ].

monitor terminate.
monitor := nil.

(Smalltalk at: #SmalltalkCI) test: buildDir, '/.smalltalk.ston'.

"Currently not reached, because SmalltalkCI>>test: closes image already"
Smalltalk snapshot: false andQuit: true.