within Buildings.Fluid.CHPs;
model ThermalElectricalFollowing


  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  redeclare package Medium = Buildings.Media.Water;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per annotation (
      choicesAllMatching=true, Placement(transformation(extent={{-98,-98},{-78,-78}})));
  parameter Modelica.SIunits.Temperature TEngIni=Medium.T_default
    "Initial engine temperature";
  parameter Modelica.SIunits.Time waitTime=60
    "Wait time before transition from pump-on mode fires"
    annotation (Dialog(tab="Dynamics"));

  Modelica.Blocks.Interfaces.BooleanInput avaSig annotation (Placement(
        transformation(extent={{-140,120},{-100,160}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput PEleDemEleFol(unit="W")
    "Electric power demand if electrical following" annotation (Placement(
        transformation(extent={{-140,80},{-100,120}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a TRoo
    "Heat port for room temperature" annotation (Placement(transformation(
          extent={{-116,-50},{-96,-30}}), iconTransformation(extent={{-120,-40},
            {-100,-20}})));
  Modelica.Blocks.Interfaces.BooleanInput theFolSig
    "Signal for thermal following (false if electrical following)" annotation (
      Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput TWatOutSet(unit="K")
    "Water outlet set point temperature  (input signal for thermal following)"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  Modelica.Blocks.Interfaces.RealOutput mWatSet(unit="kg/s") if  per.coolingWaterControl
    "Water flow rate set point based on internal control" annotation (Placement(
        transformation(extent={{100,124},{120,144}}), iconTransformation(extent=
           {{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCon(unit="W")
    "Power consumption during stand-by and cool-down modes" annotation (
      Placement(transformation(extent={{100,94},{120,114}}), iconTransformation(
          extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput PEleNet(unit="W")
    "Electric power generation" annotation (Placement(transformation(extent={{100,
            74},{120,94}}), iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput mFue_flow(unit="kg/s") "Fuel flow rate"
    annotation (Placement(transformation(extent={{100,54},{120,74}}),
        iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput QWat(unit="W")
    "Heat transfer to the water control volume" annotation (Placement(
        transformation(extent={{100,8},{120,28}}), iconTransformation(extent={{100,
            -90},{120,-70}})));

  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    annotation (Placement(transformation(extent={{-68,-97},{-48,-77}})));
  Modelica.Blocks.Sources.RealExpression TWatOut(y=eleFol.vol.T)
    "Water outlet temperature"
    annotation (Placement(transformation(extent={{-86,16},{-66,36}})));
  ElectricalFollowing eleFol(
    m_flow_nominal=m_flow_nominal,
    per=per,
    TEngIni=TEngIni)
    annotation (Placement(transformation(extent={{40,78},{60,98}})));
  Modelica.Blocks.Continuous.LimPID PID(
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=1,
    Ti=0.5,
    yMax=1,
    yMin=0) annotation (Placement(transformation(extent={{-72,38},{-52,58}})));
  Modelica.Blocks.Math.Gain PEleDemTheFol(k=per.PEleMax)
    "Electric power demand if thermal following"
    annotation (Placement(transformation(extent={{-40,38},{-20,58}})));
  Modelica.Blocks.Logical.Switch PEleDem "Electric power demand"
    annotation (Placement(transformation(extent={{-6,102},{14,82}})));


  Modelica.Blocks.Logical.Switch switch1
    "Check if there is a need for heat generation"
    annotation (Placement(transformation(extent={{-10,22},{10,42}})));
  Modelica.Blocks.Sources.Constant const(k=0)
    annotation (Placement(transformation(extent={{-68,4},{-56,16}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=273.15 +
        1) annotation (Placement(transformation(extent={{-40,14},{-28,26}})));
equation
  connect(mFue_flow, mFue_flow)
    annotation (Line(points={{110,64},{110,64}}, color={0,0,127}));
  connect(TRoo, eleFol.TRoo) annotation (Line(points={{-106,-40},{30,-40},{30,85},
          {39,85}}, color={191,0,0}));
  connect(TWatOut.y, PID.u_m)
    annotation (Line(points={{-65,26},{-62,26},{-62,36}}, color={0,0,127}));
  connect(PID.y, PEleDemTheFol.u)
    annotation (Line(points={{-51,48},{-42,48}}, color={0,0,127}));
  connect(TWatOutSet, PID.u_s) annotation (Line(points={{-120,20},{-90,20},{-90,
          48},{-74,48}}, color={0,0,127}));
  connect(theFolSig, PEleDem.u2) annotation (Line(points={{-120,60},{-80,60},{-80,
          92},{-8,92}}, color={255,0,255}));
  connect(PEleDem.y, eleFol.PEleDem)
    annotation (Line(points={{15,92},{38,92}}, color={0,0,127}));
  connect(avaSig, eleFol.avaSig) annotation (Line(points={{-120,140},{20,140},{20,
          96},{38,96}}, color={255,0,255}));
  connect(eleFol.mWatSet, mWatSet) annotation (Line(points={{61,97},{70,97},{70,
          98},{80,98},{80,134},{110,134}}, color={0,0,127}));
  connect(eleFol.PCon, PCon) annotation (Line(points={{61,94},{88,94},{88,104},
          {110,104}},color={0,0,127}));
  connect(eleFol.mFue_flow, mFue_flow) annotation (Line(points={{61,84},{76,84},
          {76,64},{110,64}}, color={0,0,127}));
  connect(eleFol.QWat, QWat) annotation (Line(points={{61,80},{68,80},{68,18},{110,
          18}}, color={0,0,127}));
  connect(port_a, eleFol.port_a) annotation (Line(points={{-100,0},{20,0},{20,88},
          {40,88}}, color={0,127,255}));
  connect(eleFol.port_b, port_b) annotation (Line(points={{60,88},{64,88},{64,0},
          {100,0}}, color={0,127,255}));
  connect(PEleNet, eleFol.PEleNet) annotation (Line(points={{110,84},{88,84},{
          88,91},{61,91}}, color={0,0,127}));
  connect(switch1.y, PEleDem.u1) annotation (Line(points={{11,32},{16,32},{16,
          64},{-14,64},{-14,84},{-8,84}}, color={0,0,127}));
  connect(PEleDemEleFol, PEleDem.u3)
    annotation (Line(points={{-120,100},{-8,100}}, color={0,0,127}));
  connect(PEleDemTheFol.y, switch1.u1) annotation (Line(points={{-19,48},{-16,
          48},{-16,40},{-12,40}}, color={0,0,127}));
  connect(const.y, switch1.u3) annotation (Line(points={{-55.4,10},{-20,10},{
          -20,24},{-12,24}}, color={0,0,127}));
  connect(greaterThreshold.u, TWatOutSet)
    annotation (Line(points={{-41.2,20},{-120,20}}, color={0,0,127}));
  connect(greaterThreshold.y, switch1.u2) annotation (Line(points={{-27.4,20},{
          -23.75,20},{-23.75,32},{-12,32}}, color={255,0,255}));
  annotation (
    defaultComponentName="theEleFol",
    Diagram(coordinateSystem(extent={{-100,-100},{100,160}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(extent={{-100,-100},{100,100}}, lineColor={0,0,127}),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-114},{151,-154}},
          lineColor={0,0,255},
          textString="%name")}),
    Documentation(info="<html>
<p>
Add description of the model. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalElectricalFollowing;
