within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block DXHeatingVol2 "Heating operation"
//   extends
//     Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialCoilCondition(    speShiEIR(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
//       variableSpeedCoil=variableSpeedCoil),
//       speShiQ_flow(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
//       variableSpeedCoil=variableSpeedCoil));

  extends Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialDryCoil(
      appDryPt(
      redeclare package Medium = Medium,
      datHP=datHP,
      variableSpeedCoil=true,
      nSta=datHP.nHeaSta));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData                       datHP
    "Heat pump performance data";

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,66},{-100,86}})));
  Modelica.Blocks.Interfaces.RealInput m2_flow "Air mass flow rate"
     annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Modelica.Blocks.Interfaces.RealInput Q_flow "Heat added to Vol2"
     annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
equation
  connect(speRat, appDryPt.speRat) annotation (Line(
      points={{-110,76},{-36,76},{-36,-53},{39,-53}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, appDryPt.mode) annotation (Line(
      points={{-110,100},{-60,100},{-60,-50},{39,-50}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(Q_flow, appDryPt.Q_flow) annotation (Line(
      points={{-110,5.55112e-16},{-68,5.55112e-16},{-68,-56.1},{39,-56.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m2_flow, appDryPt.m_flow) annotation (Line(
      points={{-110,20},{-46,20},{-46,-59},{39,-59}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="dxHea",Diagram(graphics));
end DXHeatingVol2;
