within Buildings.Airflow.Multizone;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <code>Buildings.Airflow.Multizone</code> contains models for
multizone airflow and contaminant transport.
</p>
<p>
The models can be used to compute the air flow between different rooms
and between a room and the exterior environment. In multizone airflow models, typically each room volume is assumed
to be completely mixed.
The driving force for the air flow are pressure differences that
can be induced, e.g., by
</p>
<ul>
<li>
flow imbalance of the HVAC system,
</li>
<li>
density difference across large openings such as doors or open windows,
</li>
<li>
stack effects in high rise buildings, and
</li>
<li>
wind pressure on the building facade.
</li>
</ul>
<p>
Models for air flow through openings are in this package, while the models
for wind pressure and outdoor air conditions are in the package
<a href=\"modelica://Buildings.Fluid.Sources\">Buildings.Fluid.Sources</a>.
</p>
<p>
Most models in this package are as described in Wetter (2005).
Wind pressure coefficients for different building configurations can be found
in Costola <i>et al.</i> (2009), Persily and Ivy (2001), Swami and Chandra (1987) and Liddament (1996).
</p>
<h4>References</h4>
<ul>
<li>D. Costola, B. Blocken and J.L.M. Hensen. Overview of pressure coefficient data in building energy simulation and airflow network programs. <i>Building and Environment</i>. Vol. 44(10): 2027-2036. 2009. </li>
<li>Muthusamy V. Swami and Subrato Chandra. <i><a href=\"http://www.fsec.ucf.edu/en/publications/pdf/FSEC-CR-163-86.pdf\">Procedures for Calculating Natural Ventilation Airflow Rates in Buildings.</a></i> Florida Solar Energy Center, FSEC-CR-163-86. March, 1987. Cape Canaveral, Florida. </li>
<li>Andrew K. Persily and Elizabeth M. Ivy. <i><a href=\"http://ws680.nist.gov/publication/get_pdf.cfm?pub_id=860831\">Input Data for Multizone Airflow and IAQ Analysis.</a></i> NIST, NISTIR 6585. January, 2001. Gaithersburg, MD. </li>
<li>Michael Wetter. <a href=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">Multizone Airflow Model in Modelica.</a> Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006. </li>
<li>W. S. Dols and B. J. Polidoro,2015. <i>CONTAM User Guide and Program Documentation Version 3.2</i>, National Institute of Standards and Technology, NIST TN 1887, Sep. 2015. doi: <a href=\"https://doi.org/10.6028/NIST.TN.1887\">10.6028/NIST.TN.1887</a>. </li>
<li>M. W. Liddament, 1996, <i><a href=\"https://www.aivc.org/sites/default/files/members_area/medias/pdf/Guides/GU03%20GUIDE%20TO%20ENERGY%20EFFICIENT%20VENTILATION.pdf\">A guide to energy efficient ventilation</a></i>. AIVC Annex V. </li>
</ul>
<h4>Acknowledgements</h4>
<p>
We would like to thank the <a href=\"http://www.utrc.utc.com\">
United Technologies Research Center</a> for contributing the original package
to the <code>Buildings</code> library.
</p>
<p>
We would like to thank the Research Foundation Flanders (FWO) and Ghent University for providing
the oportunity to further develop this package.
</p>
</html>", revisions="<html>
<ul>
<li>
Apr 6, 2021, by Klaas De Jonge:<br/>
Generalised UserGuide to fit the updated package better.
</li>
<li>
2006, by Michael Wetter:<br/>
First Implementation.
</li>
</ul>
</html>"));

end UsersGuide;
