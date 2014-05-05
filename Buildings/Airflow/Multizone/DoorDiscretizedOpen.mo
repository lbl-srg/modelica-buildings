within Buildings.Airflow.Multizone;
model DoorDiscretizedOpen
  "Door model using discretization along height coordinate"
  extends Buildings.Airflow.Multizone.BaseClasses.DoorDiscretized;

protected
  constant Real mFixed = 0.5 "Fixed value for flow coefficient";
  constant Real gamma(min=1) = 1.5
    "Normalized flow rate where dphi(0)/dpi intersects phi(1)";
  constant Real a = gamma
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real b = 1/8*mFixed^2 - 3*gamma - 3/2*mFixed + 35.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real c = -1/4*mFixed^2 + 3*gamma + 5/2*mFixed - 21.0/4
    "Polynomial coefficient for regularized implementation of flow resistance";
  constant Real d = 1/8*mFixed^2 - gamma - mFixed + 15.0/8
    "Polynomial coefficient for regularized implementation of flow resistance";
equation
  m=mFixed;
  A = wOpe*hOpe;
  kVal = CD*dA*sqrt(2/rho_default);
  // orifice equation
  for i in 1:nCom loop
    dV_flow[i] = Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM(
      k=kVal,
      dp=dpAB[i],
      m=mFixed,
      a=a,
      b=b,
      c=c,
      d=d,
      dp_turbulent=dp_turbulent);
  end for;

  annotation (defaultComponentName="doo",
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
</p>
</html>",
revisions="<html>
<ul>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li><i>December 6, 2011</i> by Michael Wetter:<br/>
       Changed the computation of the discharge coefficient to use the
       nominal density instead of the actual density.
       Computing <code>sqrt(2/rho)</code> sometimes causes warnings from the solver,
       as it seems to try negative values for the density during iterative solutions.
</li>
<li><i>August 12, 2011</i> by Michael Wetter:<br/>
       Changed model to use the new function
       <a href=\"modelica://Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM\">
       Buildings.Airflow.Multizone.BaseClasses.powerLawFixedM</a>.
</li>
<li><i>July 20, 2010</i> by Michael Wetter:<br/>
       Migrated model to Modelica 3.1 and integrated it into the Buildings library.
</li>
<li><i>February 10, 2005</i> by Michael Wetter:<br/>
       Released first version.
</ul>
</html>"));
end DoorDiscretizedOpen;
