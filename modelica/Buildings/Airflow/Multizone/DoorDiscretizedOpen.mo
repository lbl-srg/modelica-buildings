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
Documentation(info="<html>
<p>
This model describes the bi-directional air flow through an open door.
<P>
To compute the bi-directional flow, 
the door is discretize along the height coordinate, and uses
an orifice equation to compute the flow for each compartment.
<P>
In this model, the door is always open.
Use the model 
<code>Buildings.Airflow.Multizone.DoorDiscretizedOperable</code>
for a door that can either be open or closed, and the model
<code>Buildings.Airflow.Multizone.Cracke</code> for a door
that is always closed.

<h3>Main Author</h3>
<P>
    Michael Wetter<br>
    <a href=\"http://www.utrc.utc.com\">United Technologies Research Center</a><br>
    411 Silver Lane<br>
    East Hartford, CT 06108<br>
    USA<br>
    email: <A HREF=\"mailto:WetterM@utrc.utc.com\">WetterM@utrc.utc.com</A>
<h3>Release Notes</h3>
<P>
<ul>
<li><i>February 10, 2005</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"));
end DoorDiscretizedOpen;
