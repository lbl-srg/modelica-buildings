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
and between a room and the exterior environment.
In multizone airflow models, typically each room volume is assumed
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
Wind pressure coefficients for different building configurations can be found
in Costola <i>et al.</i> (2009), Persily and Ivy (2001), and Swami and Chandra (1987).
</p>
<p>
The models in this package are as described in Wetter (2005),
except for the addition of the model
<a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise\">
Buildings.Airflow.Multizone.BaseClasses.windPressureLowRise</a>
that computes the wind pressure on facades, and
some changes that have been done when migrating
the models to Modelica 3.1, which led to a simpler implementation based
on the stream functions.
</p>
<h4>Acknowledgements</h4>
<p>
We would like to thank the <a href=\"http://www.utrc.utc.com\">
United Technologies Research Center</a> for contributing this package
to the <code>Buildings</code> library.
</p>
<h4>References</h4>
<p>
D. Costola, B. Blocken and J.L.M. Hensen.
Overview of pressure coefficient data in building energy simulation
and airflow network programs.
<i>Building and Environment</i>. Vol. 44(10): 2027-2036. 2009.
</p>
<p>
Muthusamy V. Swami and
Subrato Chandra.
<i>
<a href=\"http://www.fsec.ucf.edu/en/publications/pdf/FSEC-CR-163-86.pdf\">
Procedures for
Calculating Natural
Ventilation Airflow
Rates in Buildings.</a></i>
Florida Solar Energy Center, FSEC-CR-163-86. March, 1987.
Cape Canaveral, Florida.
</p>
<p>
Andrew K. Persily and Elizabeth M. Ivy.
<i>
<a href=\"www.bfrl.nist.gov/IAQanalysis/docs/NISTIR6585.pdf\">
Input Data for Multizone Airflow and IAQ Analysis.</a></i>
NIST, NISTIR 6585.
January, 2001.
Gaithersburg, MD.
</p>
<p>
Michael Wetter.
<a href=\"modelica://Buildings/Resources/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">
Multizone Airflow Model in Modelica.</a>
Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006.
</p>
</html>"));

end UsersGuide;
