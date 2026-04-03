
<!--#echo json="package.json" key="name" underline="=" -->
spyplusplus-ci-extractor-260228
===============================
<!--/#echo -->

<!--#echo json="package.json" key="description" -->
Uses GitHub CI to extract the Windows debugging tool spy++.exe from Microsoft
Visual Studio.
<!--/#echo -->



Motivation
----------

Originally I was looking for an `xev` alternative for Windows: A tool that
prints what keyboard and mouse events are sent to an application window.
I found [a recommendation](https://serverfault.com/questions/7670) for
[Spy++][spypp-mslearn], part of the debugging tools for Visual Studio.

Unfortunately, the Visual Studio download provided by Microsoft is huge.
A tiny tool buried in a lot of useless-for-me data. Other people had the
same problem, and thus there are lot of GitHub repos that claim to provide
the desired files extracted from the huge download.

__The problem__ with those is, there are no official cryptographic checksums
(or at least I couldn't find them), so there's no easy way to check whether
the files in those repos are legit.

__My solution__ is to provide a free software extractor that anyone can
verify and run on GitHub CI to obtain those files, without a need to waste
lots of resources on their own machine.

Unfortunately since it's not free software, I won't be able to legally share
the resulting CI artifacts. Instead, you'll have waste time and energy
to clone the repo and run the CI job for yourself.
Microsoft, please provide better, environmentally-friendly download strategies!

  [spypp-mslearn]: https://learn.microsoft.com/en-us/visualstudio/debugger/introducing-spy-increment?view=visualstudio


⚠ Why the preinstalled version is marked as "TAINTED" ⚠
-------------------------------------------------------

GitHub's `windows-latest` image contains a pre-installed version of Spy++.
Independent of whether it may or may not be binary identical to the community
edition that Microsoft offers as a free download, to my understanding of the
license (I'm not a lawyer) that is not an officially permissible way to obtain
a copy for personal use (in the sense of actually running it).
It's exposed only for diagnostic purposes, like verifying that the actual
extractors will obtain different files.






Known issues
------------

* Needs more/better tests and docs.





<!--#toc stop="scan" -->

&nbsp;


License
-------
<!--#echo json="package.json" key="license" -->
ISC
<!--/#echo -->
