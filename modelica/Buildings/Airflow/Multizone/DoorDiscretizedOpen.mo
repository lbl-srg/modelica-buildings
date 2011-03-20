within Buildings.Airflow.Multizone;
model DoorDiscretizedOpen
  "Door model using discretization along height coordinate"
  extends Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized;

equation
  m=0.5;
  A = wOpe*hOpe;
  kVal = CD*dA*sqrt(2/rhoAve);
  annotation (Diagram(graphics),
                       Icon(graphics),
defaultComponentName="doo",
Documentation(info="<html>
<p>
This model describes the bi-directional air flow through an open door.
</p>
<p>
To compute the bi-directional flow, 
the door is discretize along the height coordinate. 
An orifice equation is used to compute the flow for each compartment.
</p>
<p>
In this model, the door is always open.
Use the model 
<a href=\"modelica://Buildings.Airflow.Multizone.DoorDiscretizedOperable\">
Buildings.Airflow.Multizone.DoorDiscretizedOperable</a>
for a door that can either be open or closed.
</html>",
revisions="<html>
<ul>
<li><i>July 20, 2010</i> by Michael Wetter:<br>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 10, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end DoorDiscretizedOpen;
