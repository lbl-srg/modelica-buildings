within Buildings.Airflow.Multizone;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;
  annotation (DocumentationClass=true, Documentation(info="<html>
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
<UL>
<LI>
flow imbalance of the HVAC system,
<LI>
density difference across large openings such as doors or open windows,
<LI>
stack effects in high rise buildings, and
<LI>
wind pressure on the building facade.
</UL>
</p>
<p>
Wind pressure coefficients for different building configurations can be found
in Costola <i>et al.</i> (2009). 
</p>
<p>  
The models in this package are as described in Wetter (2005), 
except for some changes that have been done when migrating 
them to Modelica 3.1, which led to a simpler implementation based
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
Michael Wetter.
<a href=\"modelica://Buildings/Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">
Multizone Airflow Model in Modelica.</a>
Proc. of the 5th International Modelica Conference, p. 431-440. Vienna, Austria, September 2006.
</html>"));

end UsersGuide;
