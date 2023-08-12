within Buildings.Controls.OBC.RooftopUnits.DefrostCycle;
block DefrostCycle "Sequences to control defrost cycle"
  extends Modelica.Blocks.Icons.Block;

  parameter Real TOutLoc(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") = 273.15 + 5
    "Predefined outdoor lockout temperature"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real timPer4(
    final unit="s",
    displayUnit="s",
    final quantity="time") = 300
    "Delay time period for enabling defrost"
    annotation (Dialog(tab="DX coil", group="DX coil parameters"));

  parameter Real dTHys2(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")=0.05
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  parameter Boolean have_TFroSen=false
    "True: RTU has frost sensor"
    annotation (__cdl(ValueInReference=false));

  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=0
    "Maximum temperature at which defrost operation is activated"
    annotation (Dialog(group="Defrost parameters"));

  parameter Real pAtm(
    final quantity="Pressure",
    final unit="Pa")=101325
    "Atmospheric pressure";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput phi(
    final min=0,
    final max=1)
    "Relative air humidity"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TFroSen(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_TFroSen
    "Measured temperature from frost sensor"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDefFra(
    final unit="1")
    "Defrost operation timestep fraction"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LessThreshold lesThr(
    final t=TOutLoc,
    final h=dTHys2)
    "Check if outdoor air temperature is less than threshold"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(
    final t=timPer4) "Count time"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    "Convert Boolean to Real number"
    annotation (Placement(transformation(extent={{0,42},{20,62}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul1
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.RooftopUnits.DefrostCycle.Subsequences.HumidityRatio_TDryBulPhi wBulPhi(
    final pAtm=pAtm)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));

  Buildings.Fluid.DXSystems.Heating.BaseClasses.CoilDefrostTimeCalculations defTimFra(
    defTri=Buildings.Fluid.DXSystems.Heating.BaseClasses.Types.DefrostTimeMethods.onDemand,
    TDefLim=TDefLim)
    annotation (Placement(transformation(extent={{46,-18},{66,2}})));

equation
  connect(lesThr.u, TOut)
    annotation (Line(points={{-102,60},{-160,60}},color={0,0,127}));
  connect(lesThr.y, tim.u)
    annotation (Line(points={{-78,60},{-52,60}}, color={255,0,255}));
  connect(TOut, wBulPhi.TOut) annotation (Line(points={{-160,60},{-110,60},{
          -110,-4},{-82,-4}},
                          color={0,0,127}));
  connect(wBulPhi.phi, phi) annotation (Line(points={{-82,-16},{-130,-16},{-130,
          0},{-160,0}},     color={0,0,127}));
  connect(wBulPhi.Xout, defTimFra.XOut) annotation (Line(points={{-58,-10},{45,
          -10}},                     color={0,0,127}));
  connect(defTimFra.TOut, TOut) annotation (Line(points={{45,-6},{-40,-6},{-40,20},
          {-110,20},{-110,60},{-160,60}},
                          color={0,0,127}));
  if not have_TFroSen then
  connect(TFroSen, defTimFra.TOut) annotation (Line(points={{-160,-60},{-40,-60},
            {-40,-6},{45,-6}},  color={0,0,127}));
  end if;
  if not have_TFroSen then
  connect(TFroSen, lesThr.u) annotation (Line(points={{-160,-60},{-120,-60},{-120,
            60},{-102,60}},                   color={0,0,127}));
  end if;
  connect(mul1.y, yDefFra)
    annotation (Line(points={{122,0},{160,0}}, color={0,0,127}));
  connect(tim.passed, booToRea.u)
    annotation (Line(points={{-28,52},{-2,52}}, color={255,0,255}));
  connect(booToRea.y, mul1.u1)
    annotation (Line(points={{22,52},{92,52},{92,6},{98,6}}, color={0,0,127}));
  connect(defTimFra.tDefFra, mul1.u2)
    annotation (Line(points={{67,-4},{67,-6},{98,-6}}, color={0,0,127}));
  annotation (defaultComponentName="DefCyc",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
          Text(
            extent={{-100,66},{-62,52}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TOut"),
          Text(
            extent={{-100,6},{-68,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="Phi"),
          Text(
            extent={{-94,-52},{-48,-72}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="TFroSen"),
          Text(
            extent={{48,8},{94,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yDefFra")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})));
end DefrostCycle;
