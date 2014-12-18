within Buildings.Obsolete.Fluid.Movers;
model FlowMachine_y
  "Fan or pump with ideally controlled normalized speed y as input signal"
  extends Buildings.Obsolete.Fluid.Movers.BaseClasses.PrescribedFlowMachine(
  final N_nominal=1500 "fix N_nominal as it is used only for scaling");

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    "Constant normalized rotational speed"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={0,120})));

protected
  Modelica.Blocks.Math.Gain gaiSpe(final k=N_nominal,
    u(min=0, max=1),
    y(final quantity="AngularVelocity",
      final unit="1/min",
      nominal=N_nominal)) "Gain for speed input signal"
    annotation (Placement(transformation(extent={{-6,64},{6,76}})));
equation
  connect(y, gaiSpe.u) annotation (Line(
      points={{1.11022e-15,120},{0,104},{0,104},{0,92},{-20,92},{-20,70},{-7.2,
          70}},
      color={0,0,127},
      smooth=Smooth.None));

   connect(filter.y, N_filtered) annotation (Line(
      points={{34.7,88},{50,88}},
      color={0,0,127},
      smooth=Smooth.None));

  if filteredSpeed then
    connect(gaiSpe.y, filter.u) annotation (Line(
      points={{6.6,70},{12.6,70},{12.6,88},{18.6,88}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(filter.y, N_actual) annotation (Line(
      points={{34.7,88},{38,88},{38,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(gaiSpe.y, N_actual) annotation (Line(
      points={{6.6,70},{50,70}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  annotation (defaultComponentName="fan",
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={Text(extent={{10,124},{102,102}},textString=
              "y_in [0, 1]")}),
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
       Model added to the Buildings library. Changed control signal from rpm to normalized value between 0 and 1</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
end FlowMachine_y;
