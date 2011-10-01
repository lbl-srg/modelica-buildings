within Buildings.Fluid.Movers;
model FlowMachine_y
  "Fan or pump with ideally controlled normalized speed y as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine(
  final N_nominal=1500 "fix N_nominal as it is used only for scaling");

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
    "Constant normalized rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

equation
  N = y*N_nominal;
  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{20,100},{112,78}}, textString=
              "y_in [0, 1]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<html>
<p>
This model describes a fan or pump with prescribed normalized speed.
The input connector provides the normalized rotational speed (between 0 and 1).
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
</p>
<p>
See the 
<a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 25, 2011, by Michael Wetter:<br>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br>
       Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end FlowMachine_y;
