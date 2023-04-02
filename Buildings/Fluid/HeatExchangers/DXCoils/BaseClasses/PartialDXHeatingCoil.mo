within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil "Partial model for DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final activate_CooCoi=false,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
      redeclare package Medium = Medium),
    datCoi(final activate_CooCoi=false));

  replaceable parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost datDef
    "Record for defrost data";

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations defTim(
    final defTri=datDef.defTri,
    final tDefRun=datDef.tDefRun,
    final TDefLim=datDef.TDefLim)
    "Block to compute defrost time fraction, heat transfer multiplier and input power multiplier"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostCapacity defCap(
    final defTri=datDef.defTri,
    final defOpe=datDef.defOpe,
    final tDefRun=datDef.tDefRun,
    final defCur=datDef,
    redeclare package MediumA = Medium,
    final QDefResCap=datDef.QDefResCap)
    "Block to compute actual heat transferred to medium and power input after accounting for defrost"
    annotation (Placement(transformation(extent={{60,-62},{80,-42}})));

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final displayUnit="kg/kg",
    final quantity="MassFraction")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));

  Modelica.Blocks.Sources.RealExpression p_in(
    final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

equation
  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-60,28},{-60,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut,defTim. TOut) annotation (Line(points={{-110,30},{-92,30},{-92,-38},
          {29,-38}}, color={0,0,127}));
  connect(defTim.tFracDef, defCap.tFracDef) annotation (Line(points={{51,-36},{54.5,
          -36},{54.5,-43},{59,-43}}, color={0,0,127}));
  connect(defTim.heaCapMul, defCap.heaCapMul) annotation (Line(points={{51,-40},
          {54,-40},{54,-46},{59,-46}}, color={0,0,127}));
  connect(defTim.inpPowMul, defCap.inpPowMul) annotation (Line(points={{51,-44},
          {54,-44},{54,-49},{59,-49}}, color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-34,28},{-34,-52},
          {59,-52}}, color={0,0,127}));
  connect(XOut,defTim. XOut) annotation (Line(points={{-110,14},{20,14},{20,-42},
          {29,-42}}, color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot) annotation (Line(points={{1,56},{22,56},{22,
          -68},{59,-68}},    color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,-64},
          {59,-64}},      color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,-61},
          {59,-61}}, color={0,0,127}));
  connect(defCap.QTotDef, q.Q_flow) annotation (Line(points={{81,-60},{94,-60},{
          94,10},{32,10},{32,54},{42,54}}, color={0,0,127}));
  connect(defCap.QTotDef, QSen_flow) annotation (Line(points={{81,-60},{94,-60},
          {94,70},{110,70}}, color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{81,-48},{82,-48},{82,90},{110,
          90}}, color={0,0,127}));
  connect(p_in.y, defCap.pIn) annotation (Line(points={{-69,-70},{-40,-70},{-40,
          -58},{59,-58}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedHeating</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-138,64},{-80,46}},
          textColor={0,0,127},
          textString="TConIn"), Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,60},{98,40}},
          textColor={0,0,127},
          textString="QLat"),   Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen")}));
end PartialDXHeatingCoil;
