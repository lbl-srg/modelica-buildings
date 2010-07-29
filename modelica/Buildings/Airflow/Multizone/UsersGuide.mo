within Buildings.Airflow.Multizone;
package UsersGuide "User's Guide"

  annotation (DocumentationClass=true, Documentation(info="<html>
The package <b>Buildings.Airflow.Multizone</b> contains multizone airflow 
models.
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
The model complexity is comparable with the models used in CONTAM or
COMIS.  
The models in this package are as described in Wetter (2005), 
except for some changes that have been done when migrating 
them to Modelica 3.1, which led to a simpler implementation based
on the stream functions.
</p>
<h4>References</h4>

Michael Wetter.
<a href=\"../Images/Airflow/Multizone/Wetter-airflow-2006.pdf\">
Multizone Airflow Model in Modelica.</a>
Proc. of the 5th International Modelica Conference, p. 431--440. Vienna, Austria, September 2006.
</html>"));

end UsersGuide;
