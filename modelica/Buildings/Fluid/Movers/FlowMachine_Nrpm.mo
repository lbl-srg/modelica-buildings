within Buildings.Fluid.Movers;
model FlowMachine_Nrpm
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Fluid.Movers.BaseClasses.PrescribedFlowMachine;

  Modelica.Blocks.Interfaces.RealInput Nrpm(unit="1/min")
    "Prescribed rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,100})));

equation
  N = Nrpm;
  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{20,100},{118,78}}, textString=
              "N_in [rpm]")}),
    Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{
            100,100}}), graphics),
    Documentation(info="<HTML>
This model describes a fan or pump with prescribed speed in revolutions per minute.
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
</HTML>",
      revisions="<html>
<ul>
<li><i>March 24, 2010</i> by Michael Wetter:<br>
Revised implementation to allow zero flow rate.
</li>
<li><i>October 1, 2009</i>
    by Michael Wetter:<br>
       Model added to the Buildings library. 
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Model added to the Fluid library</li>
</ul>
</html>"));
end FlowMachine_Nrpm;
