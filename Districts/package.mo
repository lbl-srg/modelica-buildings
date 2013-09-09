within ;
package Districts "Library with models for district energy and control systems"
  extends Modelica.Icons.Package;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
  class Conventions "Conventions"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<p>
This library follows the conventions of the 
<a href=\"modelica://Buildings\">Buildings</a> library.
</p>
</html>
"));
  end Conventions;

  package ReleaseNotes "Release notes"
    extends Modelica.Icons.ReleaseNotes;

  class Version_0_1_build0 "Version 0.1 build 0"
    extends Modelica.Icons.ReleaseNotes;
     annotation (Documentation(info="<html>
<p>
Version X.Y build Z is ... xxx
</p>
<!-- New libraries -->
<p>
The following <b style=\"color:blue\">new libraries</b> have been added:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
    </tr>
</table>
</p>
<!-- New components for existing libraries -->
<p>
The following <b style=\"color:blue\">new components</b> have been added
to <b style=\"color:blue\">existing</b> libraries:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td> 
    </tr>
</table>
</p>
<!-- Backward compatbile changes -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Non-backward compatbile changes to existing components -->
<p>
The following <b style=\"color:blue\">existing components</b>
have been <b style=\"color:blue\">improved</b> in a
<b style=\"color:blue\">non-backward compatible</b> way:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">

<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Errors that have been fixed -->
<p>
The following <b style=\"color:red\">critical errors</b> have been fixed (i.e., errors
that can lead to wrong simulation results):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Uncritical errors -->
<p>
The following <b style=\"color:red\">uncritical errors</b> have been fixed (i.e., errors
that do <b style=\"color:red\">not</b> lead to wrong simulation results, e.g.,
units are wrong or errors in documentation):
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\">xxx
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
</p>
<!-- Trac tickets -->
<p>
The following
<a href=\"https://corbu.lbl.gov/trac/bie\">trac tickets</a>
have been fixed:
</p>
<table border=\"1\" cellspacing=0 cellpadding=2 style=\"border-collapse:collapse;\">
<tr><td colspan=\"2\"><b>xxx</b>
    </td>
</tr>
<tr><td valign=\"top\"><a href=\"https://corbu.lbl.gov/trac/bie/ticket/xxx\">#xxx</a>
    </td>
    <td valign=\"top\">xxx.
    </td>
</tr>
</table>
<p>
Note:
</p>
<ul>
<li> 
xxx
</li>
</ul>
</p>
</html>"));
  end Version_0_1_build0;

    annotation (Documentation(info="<html>
<p>
This section summarizes the changes that have been performed
on the Buildings library
</p>
<p>
<ul>
<li> 
<a href=\"modelica://District.UsersGuide.ReleaseNotes.Version_0_1_build0\">
Version 0.1 build0</a>(xxx, 2013)</li>
</li>
</ul>
</p>
<p></p>
</html>
"));
  end ReleaseNotes;

  class Contact "Contact"
    extends Modelica.Icons.Contact;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Contact</font></h4>
<p>
The development of the Buildings library is organized by<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter\">Michael Wetter</a><br/>
    Lawrence Berkeley National Laboratory (LBNL)<br/>
    One Cyclotron Road<br/> 
    Bldg. 90-3147<br/>
    Berkeley, CA 94720<br/>
    USA<br/>
    email: <A HREF=\"mailto:MWetter@lbl.gov\">MWetter@lbl.gov</A><br/>
</p>
</html>
"));
  end Contact;

  class Acknowledgements "Acknowledgements"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Acknowledgements</font></h4>
<p>
 The development of this library was supported
 by the Assistant Secretary for
  Energy Efficiency and Renewable Energy, Office of Building
  Technologies of the U.S. Department of Energy, under
  contract No. DE-AC02-05CH11231.
</p>
</html>
"));
  end Acknowledgements;

  class License "Modelica License 2"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>The Modelica License 2</font></h4>
<p>
<strong>Preamble.</strong> The goal of this license is that Modelica related model libraries, software, images, documents, data files etc. can be used freely in the original or a modified form, in open source and in commercial environments (as long as the license conditions below are fulfilled, in particular sections 2c) and 2d). The Original Work is provided free of charge and the use is completely at your own risk. Developers of free Modelica packages are encouraged to utilize this license for their work. 
<p>
The Modelica License applies to any Original Work that contains the following licensing notice adjacent to the copyright notice(s) for this Original Work: 
<p>
<strong>Note.</strong> This is the standard Modelica License 2, except for the following changes: the parenthetical in paragraph 7., paragraph 5., and the addition of paragraph 15.d). 
<p>
<strong>Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 </strong> 
 
<h4>1. Definitions</h4>
<ol type=\"a\"><li>
\"License\" is this Modelica License.
</li><li>
\"Original Work\" is any work of authorship, including software, images, documents, data files, that contains the above licensing notice or that is packed together with a licensing notice referencing it. 
</li><li>
\"Licensor\" is the provider of the Original Work who has placed this licensing notice adjacent to the copyright notice(s) for the Original Work. The Original Work is either directly provided by the owner of the Original Work, or by a licensee of the owner. 
</li><li>
\"Derivative Work\" is any modification of the Original Work which represents, as a whole, an original work of authorship. For the matter of clarity and as examples:
<ol type=\"A\">
<li>
Derivative Work shall not include work that remains separable from the Original Work, as well as merely extracting a part of the Original Work without modifying it. 
</li><li>
Derivative Work shall not include (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
Derivative Work shall include classes that are copied from the Original Work where declarations, equations or the documentation are modified. 
</li><li>
Derivative Work shall include executables to simulate the models that are generated by a Modelica translator based on the Original Work (of a Modelica package). </li>
</ol>
</li>
<li>
\"Modified Work\" is any modification of the Original Work with the following exceptions: (a) fixing of errors and/or (b) adding vendor specific Modelica annotations and/or (c) using a subset of the classes of a Modelica package, and/or (d) using a different representation, e.g., a binary representation. 
</li><li>
\"Source Code\" means the preferred form of the Original Work for making modifications to it and all available documentation describing how to modify the Original Work. 
</li><li>
\"You\" means an individual or a legal entity exercising rights under, and complying with all of the terms of, this License. 
</li><li>
\"Modelica package\" means any Modelica library that is defined with the
 <b>package</b> &lt;Name&gt; ... <b>end</b> &lt;Name&gt;<b>;</b> Modelica language element.
</li>
</ol>
 
<h4>2. Grant of Copyright License</h4>
<p>
Licensor grants You a worldwide, royalty-free, non-exclusive, sublicensable license, for the duration of the copyright, to do the following: 
<ol type=\"a\">
<li>
To reproduce the Original Work in copies, either alone or as part of a collection. 
</li><li>
To create Derivative Works according to Section 1d) of this License. 
</li><li>
To distribute or communicate to the public copies of the <u>Original Work</u> or a <u>Derivative Work</u> under <u>this License</u>. No fee, neither as a copyright-license fee, nor as a selling fee for the copy as such may be charged under this License. Furthermore, a verbatim copy of this License must be included in any copy of the Original Work or a Derivative Work under this License. 
<br/>
For the matter of clarity, it is permitted A) to distribute or communicate such copies as part of a (possible commercial) collection where other parts are provided under different licenses and a license fee is charged for the other parts only and B) to charge for mere printing and shipping costs. 
</li><li>
To distribute or communicate to the public copies of a <u>Derivative Work</u>, alternatively to Section 2c), under <u>any other license</u> of your choice, especially also under a license for commercial/proprietary software, as long as You comply with Sections 3, 4 and 8 below. 
<br/>
For the matter of clarity, no restrictions regarding fees, either as to a copyright-license fee or as to a selling fee for the copy as such apply. 
</li><li>
To perform the Original Work publicly. 
</li><li>
To display the Original Work publicly. 
</li></ol><p>
<h4>3. Acceptance</h4>
<p>
Any use of the Original Work or a Derivative Work, or any action according to either Section 2a) to 2f) above constitutes Your acceptance of this License. 
<p>
<h4>4. Designation of Derivative Works and of Modified Works</h4>
 
<p>
The identifying designation of Derivative Work and of Modified Work must be different to the corresponding identifying designation of the Original Work. This means especially that the (root-level) name of a Modelica package under this license must be changed if the package is modified (besides fixing of errors, adding vendor specific Modelica annotations, using a subset of the classes of a Modelica package, or using another representation, e.g. a binary representation). <p>
 
<h4>5. [reserved]</h4>
<p>
<h4>6. Provision of Source Code</h4>
<p>Licensor agrees to provide You with a copy of the Source Code of the Original Work but reserves the right to decide freely on the manner of how the Original Work is provided. For the matter of clarity, Licensor might provide only a binary representation of the Original Work. In that case, You may (a) either reproduce the Source Code from the binary representation if this is possible (e.g., by performing a copy of an encrypted Modelica package, if encryption allows the copy operation) or (b) request the Source Code from the Licensor who will provide it to You. 
<p>
<h4>7. Exclusions from License Grant</h4>
<p>
Neither the names of Licensor (including, but not limited to, University of California, Lawrence Berkeley National Laboratory, U.S. Dept. of Energy, UC, LBNL, LBL, and DOE), nor the names of any contributors to the Original Work, nor any of their trademarks or service marks, may be used to endorse or promote products derived from this Original Work without express prior permission of the Licensor. Except as otherwise expressly stated in this License and in particular in Sections 2 and 5, nothing in this License grants any license to Licensor's trademarks, copyrights, patents, trade secrets or any other intellectual property, and no patent license is granted to make, use, sell, offer for sale, have made, or import embodiments of any patent claims. 
<p>
No license is granted to the trademarks of Licensor even if such trademarks are included in the Original Work, except as expressly stated in this License. Nothing in this License shall be interpreted to prohibit Licensor from licensing under terms different from this License any Original Work that Licensor otherwise would have a right to license. 
<p>
<h4>8. Attribution Rights</h4>
<p>
You must retain in the Source Code of the Original Work and of any Derivative Works that You create, all author, copyright, patent, or trademark notices, as well as any descriptive text identified therein as an \"Attribution Notice\". The same applies to the licensing notice of this License in the Original Work. For the matter of clarity, \"author notice\" means the notice that identifies the original author(s). 
<p>
You must cause the Source Code for any Derivative Works that You create to carry a prominent Attribution Notice reasonably calculated to inform recipients that You have modified the Original Work. 
<p>In case the Original Work or Derivative Work is not provided in Source Code, the Attribution Notices shall be appropriately displayed, e.g., in the documentation of the Derivative Work. <p>
 
<h4>9. Disclaimer of Warranty</h4>
<p><u><strong>The Original Work is provided under this License on an \"as is\" basis and without warranty, either express or implied, including, without limitation, the warranties of non-infringement, merchantability or fitness for a particular purpose. The entire risk as to the quality of the Original Work is with You.</strong></u> This disclaimer of warranty constitutes an essential part of this License. No license to the Original Work is granted by this License except under this disclaimer. 
<p>
<h4>10. Limitation of Liability</h4>
<p>Under no circumstances and under no legal theory, whether in tort (including negligence), contract, or otherwise, shall the Licensor, the owner or a licensee of the Original Work be liable to anyone for any direct, indirect, general, special, incidental, or consequential damages of any character arising as a result of this License or the use of the Original Work including, without limitation, damages for loss of goodwill, work stoppage, computer failure or malfunction, or any and all other commercial damages or losses. This limitation of liability shall not apply to the extent applicable law prohibits such limitation. 
<p>
<h4>11. Termination</h4>
<p>
This License conditions your rights to undertake the activities listed in Section 2 and 5, including your right to create Derivative Works based upon the Original Work, and doing so without observing these terms and conditions is prohibited by copyright law and international treaty. Nothing in this License is intended to affect copyright exceptions and limitations. This License shall terminate immediately and You may no longer exercise any of the rights granted to You by this License upon your failure to observe the conditions of this license. 
<p>
<h4>12. Termination for Patent Action</h4>
<p>
This License shall terminate automatically and You may no longer exercise any of the rights granted to You by this License as of the date You commence an action, including a cross-claim or counterclaim, against Licensor, any owners of the Original Work or any licensee alleging that the Original Work infringes a patent. This termination provision shall not apply for an action alleging patent infringement through combinations of the Original Work under combination with other software or hardware.
<p>
<h4>13. Jurisdiction</h4>
<p>
Any action or suit relating to this License may be brought only in the courts of a jurisdiction wherein the Licensor resides and under the laws of that jurisdiction excluding its conflict-of-law provisions. The application of the United Nations Convention on Contracts for the International Sale of Goods is expressly excluded. Any use of the Original Work outside the scope of this License or after its termination shall be subject to the requirements and penalties of copyright or patent law in the appropriate jurisdiction. This section shall survive the termination of this License. 
<p>
<h4>14. Attorneys' Fees</h4>
<p>
In any action to enforce the terms of this License or seeking damages relating thereto, the prevailing party shall be entitled to recover its costs and expenses, including, without limitation, reasonable attorneys' fees and costs incurred in connection with such action, including any appeal of such action. This section shall survive the termination of this License. 
<p>
<h4>15. Miscellaneous</h4>
<ol type=\"a\">
<li>If any provision of this License is held to be unenforceable, such provision shall be reformed only to the extent necessary to make it enforceable. 
</li><li>
No verbal ancillary agreements have been made. Changes and additions to this License must appear in writing to be valid. This also applies to changing the clause pertaining to written form. 
</li><li>
You may use the Original Work in all ways not otherwise restricted or conditioned by this License or by law, and Licensor promises not to interfere with or be responsible for such uses by You. 
</li><li>
You are under no obligation whatsoever to provide any bug fixes, patches, or upgrades to the features, functionality or performance of the source code (\"Enhancements\") to anyone; however, if you choose to make your Enhancements available either publicly, or directly to Lawrence Berkeley National Laboratory, without imposing a separate written license agreement for such Enhancements, then you hereby grant the following license: a non-exclusive, royalty-free perpetual license to install, use, modify, prepare derivative works, incorporate into other computer software, distribute, and sublicense such enhancements or derivative works thereof, in binary and source code form. 
</li></ol>
<p>
<h4>How to Apply the Modelica License 2</h4>
<p>
At the top level of your Modelica package and at every important subpackage, add the following notices in the info layer of the package: 
<ul><li style=\"list-style-type:none\">
Licensed by The Regents of the University of California, through Lawrence Berkeley National Laboratory under the Modelica License 2 Copyright (c) 2009-2012, The Regents of the University of California, through Lawrence Berkeley National Laboratory. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at </em><a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>
Include a copy of the Modelica License 2 under <strong>&lt;library&gt;.UsersGuide.ModelicaLicense2</strong> 
(use <a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo\">
http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.mo</a>) 
Furthermore, add the list of authors and contributors under 
<strong>&lt;library&gt;.UsersGuide.Contributors</strong> or <strong>&lt;library&gt;.UsersGuide.Contact</strong> 
<p>
For example, sublibrary Modelica.Blocks of the Modelica Standard Library may have the following notices: 
<p>
<ul><li style=\"list-style-type:none\">
Licensed by Modelica Association under the Modelica License 2 Copyright (c) 1998-2008, Modelica Association. 
<p>
<li style=\"list-style-type:none\"><i>
This Modelica package is <u>free</u> software and the use is completely at <u>your own risk</u>; it can be redistributed and/or modified under the terms of the Modelica license 2, see the license conditions (including the disclaimer of warranty) here or at 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2.html</a>. 
</i>
</li></ul>
<p>For C-source code and documents, add similar notices in the corresponding file.
<p>
For images, add a \"readme.txt\" file to the directories where the images are stored and include a similar notice in this file. 
<p>
In these cases, save a copy of the Modelica License 2 in one directory of the distribution, e.g., 
<a href=\"http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html\">http://www.modelica.org/modelica-legal-documents/ModelicaLicense2-standalone.html</a> in directory <strong>&lt;library&gt;/help/documentation/ModelicaLicense2.html</strong>. 
</p>
</html>
"));
  end License;

  class Copyright "Copyright"
    extends Modelica.Icons.Information;
    annotation (Documentation(info="<html>
<h4><font color=\"#008000\" size=5>Copyright</font></h4>
<p>
Copyright (c) 2009-2013, The Regents of the University of California, through Lawrence Berkeley National Laboratory (subject to receipt of any required approvals from the U.S. Dept. of Energy). All rights reserved.
</p><p>
If you have questions about your rights to use or distribute this software, please contact Berkeley Lab's Technology Transfer Department at 
<A HREF=\"mailto:TTD@lbl.gov\">TTD@lbl.gov</A>
</p><p>
NOTICE. This software was developed under partial funding from the U.S. Department of Energy. As such, the U.S. Government has been granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, and perform publicly and display publicly. Beginning five (5) years after the date permission to assert copyright is obtained from the U.S. Department of Energy, and subject to any subsequent five (5) year renewals, the U.S. Government is granted for itself and others acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide license in the Software to reproduce, prepare derivative works, distribute copies to the public, perform publicly and display publicly, and to permit others to do so. 
</p>
</html>
"));
  end Copyright;
  annotation (DocumentationClass=true, Documentation(info="<html>
<p>
The <code>Districts</code> library is a free open-source library for modeling of district energy and control systems. 
Eventually, this library may be integrated into the 
<a href=\"modelica://Buildings\">Buildings</a> library.
At this point, the development is still experimental.
</p>
<p>
The library has the following <i>User's Guides</i>:
</p>
<ol>
<li>
<p>
General information about the use of the <code>Districts</code> library
is available at
<a href=\"http://simulationresearch.lbl.gov/modelica/userGuide\">
http://simulationresearch.lbl.gov/modelica/userGuide</a>.
While this user guide has been written for the
<a href=\"modelica://Buildings\">Buildings</a>
library, most of it is also applicable to the <code>Districts</code> library.
This web site covers general information that is not specific to the 
use of individual sublibraries or models.
Discussed topics include 
how to get started, best practices, how to post-process results using Python,
work-around for problems and how to develop models.
</p>
</li>
<li>
<p>
Some of the main sublibraries have their own
User's Guides that can be accessed by the links below.
These User's Guides are discussing items that are specific to the
individual libraries.
</p>
<p>
<table border=1 cellspacing=0 cellpadding=2>
<tr>
   <td valign=\"top\"><a href=\"modelica://Districts.BoundaryConditions.UsersGuide\">
   Districts.BoundaryConditions.UsersGuide</a>
   </td>
   <td valign=\"top\">Library for computing boundary conditions such as weather data.</td>
</tr>
<tr>
   <td valign=\"top\"><a href=\"modelica://Districts.Electrical.AC.UsersGuide\">
   Districts.Electrical.AC.UsersGuide</a>
   </td>
   <td valign=\"top\">Library for alternate current electrical systems that are modeled as quasi stationary.</td>
</tr>
</table>
</p>
</li>
<li>
</li>
</ol>
</p>
</html>"));
end UsersGuide;






annotation (
version="0.1",
versionBuild=0,
versionDate="2012-12-21",
dateModified = "$Date: 2012-12-18 14:34:42 -0800 (Tue, 18 Dec 2012) $",
uses(Modelica(version="3.2"),
    Complex(version="1.0"),
    Buildings(version="1.5")),
revisionId="$Id: package.mo 4797 2012-12-18 22:34:42Z mwetter $",
preferredView="info",
Documentation(info="<html>
<p>
The <code>Districts</code> library is a free library
for modeling district energy and control systems. 
See
<a href=\"modelica://Districts.UsersGuide\">
Districts.UsersGuide</a>
for more information.
</p>
</html>"));
end Districts;
