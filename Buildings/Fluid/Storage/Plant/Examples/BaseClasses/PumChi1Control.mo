within Buildings.Fluid.Storage.Plant.Examples.BaseClasses;
block PumChi1Control
  "Control block"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Td=1,
    k=1,
    Ti=100,
    reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,40})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis                     hysPum1(uLow=0.05,
      uHigh=0.5)
    "Primary pump shuts off at con.yVal = 0.05 and restarts at 0.5" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-70,-40})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal                     booToReaPum1(realTrue=
        1)                "Primary pump signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,-40})));
  Modelica.Blocks.Interfaces.RealInput us_dpCon
    "Consumer pressure head setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput um_dpCon
    "Measured consumer pressure head" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,0})));
  Modelica.Blocks.Interfaces.RealInput yVal "Valve position" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-40}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Min min "Turn-off signal overrides" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,0})));
  Modelica.Blocks.Interfaces.RealOutput y "Normalised pump speed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
equation
  connect(conPI.u_s, us_dpCon)
    annotation (Line(points={{-42,40},{-110,40}}, color={0,0,127}));
  connect(hysPum1.u, yVal)
    annotation (Line(points={{-82,-40},{-110,-40}}, color={0,0,127}));
  connect(hysPum1.y, booToReaPum1.u)
    annotation (Line(points={{-58,-40},{-42,-40}}, color={255,0,255}));
  connect(conPI.y, min.u1) annotation (Line(points={{-19,40},{32,40},{32,6},{38,
          6}}, color={0,0,127}));
  connect(booToReaPum1.y, min.u2) annotation (Line(points={{-18,-40},{32,-40},{32,
          -6},{38,-6}}, color={0,0,127}));
  connect(min.y, y) annotation (Line(points={{62,0},{110,0}}, color={0,0,127}));
  connect(conPI.u_m, um_dpCon)
    annotation (Line(points={{-30,28},{-30,0},{-110,0}}, color={0,0,127}));
end PumChi1Control;
