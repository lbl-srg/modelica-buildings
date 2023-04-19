within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil "Partial model for DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final is_CooCoi=false,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
      redeclare package Medium = Medium),
    datCoi(final is_CooCoi=false));

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost datDef
    "Record for defrost data";

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final displayUnit="kg/kg",
    final quantity="MassFraction")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations
    defTimFra(
    final defTri=datDef.defTri,
    final tDefRun=datDef.tDefRun,
    final TDefLim=datDef.TDefLim)
    "Block to compute defrost time fraction, heat transfer multiplier and input power multiplier"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostCapacity defCap(
    final defTri=datDef.defTri,
    final defOpe=datDef.defOpe,
    final tDefRun=datDef.tDefRun,
    final defCur=datDef,
    redeclare package MediumA = Medium,
    final QDefResCap=datDef.QDefResCap)
    "Block to compute actual heat transferred to medium and power input after accounting for defrost"
    annotation (Placement(transformation(extent={{70,-62},{90,-42}})));

protected
  Modelica.Blocks.Sources.RealExpression p_in(
    final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,-80},{-70,-60}})));

  Modelica.Blocks.Sources.RealExpression X(
    final y=XIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

equation
  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-60,28},{-60,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut, defTimFra.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,
          -28},{29,-28}}, color={0,0,127}));
  connect(defTimFra.tDefFra, defCap.tDefFra) annotation (Line(points={{51,-26},{
          56,-26},{56,-41},{69,-41}},      color={0,0,127}));
  connect(defTimFra.heaCapMul, defCap.heaCapMul) annotation (Line(points={{51,-30},
          {54,-30},{54,-44},{69,-44}},      color={0,0,127}));
  connect(defTimFra.inpPowMul, defCap.inpPowMul) annotation (Line(points={{51,-34},
          {52,-34},{52,-47},{69,-47}},      color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-34,28},{-34,-50},
          {69,-50}}, color={0,0,127}));
  connect(XOut, defTimFra.XOut) annotation (Line(points={{-110,14},{20,14},{20,-32},
          {29,-32}},      color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot_flow) annotation (Line(points={{1,56},{22,56},
          {22,-66},{69,-66}},     color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,-63},
          {69,-63}},      color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,-60},
          {69,-60}}, color={0,0,127}));
  connect(defCap.QTotDef_flow, q.Q_flow) annotation (Line(points={{91,-60},{94,-60},
          {94,10},{32,10},{32,54},{42,54}},      color={0,0,127}));
  connect(defCap.QTotDef_flow, QSen_flow) annotation (Line(points={{91,-60},{94,
          -60},{94,70},{110,70}}, color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{91,-48},{92,-48},{92,90},{110,
          90}}, color={0,0,127}));
  connect(p_in.y, defCap.pIn) annotation (Line(points={{-69,-70},{-40,-70},{-40,
          -57},{69,-57}}, color={0,0,127}));
  connect(X.y, defCap.XConIn) annotation (Line(points={{-69,-40},{-50,-40},{-50,
          -54},{69,-54}}, color={0,0,127}));
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
