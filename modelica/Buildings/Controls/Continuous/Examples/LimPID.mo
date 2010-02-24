within Buildings.Controls.Continuous.Examples;
model LimPID "Example model"
  import Buildings;
 annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="LimPID.mos" "run"));

  Modelica.Blocks.Sources.Pulse pulse(period=0.25) 
    annotation (Placement(transformation(extent={{-80,40},{-60,60}},rotation=0)));
  Buildings.Controls.Continuous.LimPID limPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState) 
          annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.Continuous.LimPID limPIDRev(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    reverseAction=true,
    Ti=1,
    Td=1,
    yMax=1,
    yMin=-1,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
    "Controller with reverse action" 
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant const(k=0.5) 
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Math.Gain gain(k=-1) 
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(threShold=1e-10) 
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
equation
  connect(pulse.y, limPID.u_s) annotation (Line(
      points={{-59,50},{-22,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, limPIDRev.u_s) annotation (Line(
      points={{-59,50},{-45.5,50},{-45.5,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, limPID.u_m) annotation (Line(
      points={{-59,10},{-10,10},{-10,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(const.y, limPIDRev.u_m) annotation (Line(
      points={{-59,10},{-52,10},{-52,-30},{-10,-30},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPIDRev.y, gain.u) annotation (Line(
      points={{1,-10},{18,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, assertEquality.u2) annotation (Line(
      points={{41,-10},{50,-10},{50,24},{58,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limPID.y, assertEquality.u1) annotation (Line(
      points={{1,50},{30,50},{30,36},{58,36}},
      color={0,0,127},
      smooth=Smooth.None));
end LimPID;
