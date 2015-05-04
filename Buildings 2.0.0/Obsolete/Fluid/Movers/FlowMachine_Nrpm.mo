within Buildings.Obsolete.Fluid.Movers;
model FlowMachine_Nrpm
  "Fan or pump with ideally controlled speed Nrpm as input signal"
  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.PrescribedFlowMachine;

  Modelica.Blocks.Interfaces.RealInput Nrpm(unit="1/min")
    "Prescribed rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

equation
  if filteredSpeed then
    connect(Nrpm, filter.u) annotation (Line(
      points={{1.11022e-15,120},{0,104},{0,104},{0,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, N_actual) annotation (Line(
      points={{34.7,88},{38.35,88},{38.35,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, N_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));

  else
    connect(Nrpm, N_actual) annotation (Line(
      points={{1.11022e-15,120},{0,120},{0,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  annotation (defaultComponentName="pump",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{20,126},{118,104}},textString=
              "N_in [rpm]")}),
    Documentation(info="<html>
This model describes a fan or pump with prescribed speed in revolutions per minute.
The head is computed based on the performance curve that take as an argument
the actual volume flow rate divided by the maximum flow rate and the relative
speed of the fan.
The efficiency of the device is computed based
on the efficiency curves that take as an argument
the actual volume flow rate divided by the maximum possible volume flow rate, or
based on the motor performance curves.
<br/>
<p>
See the
<a href=\"modelica://Buildings.Obsolete.Fluid.Movers.UsersGuide\">
User's Guide</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 14, 2012, by Michael Wetter:<br/>
Added filter for start-up and shut-down transient.
</li>
<li>
May 25, 2011, by Michael Wetter:<br/>
Revised implementation of energy balance to avoid having to use conditionally removed models.
</li>
<li>
July 27, 2010, by Michael Wetter:<br/>
Redesigned model to fix bug in medium balance.
</li>
<li>March 24, 2010, by Michael Wetter:<br/>
Revised implementation to allow zero flow rate.
</li>
<li>October 1, 2009,
    by Michael Wetter:<br/>
       Model added to the Buildings library.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
end FlowMachine_Nrpm;
