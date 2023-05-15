within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil
  "Partial model for DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final is_cooCoi=datCoi.is_cooCoi,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
      redeclare package Medium = Medium,
      redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil datCoi),
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.HeatingCoil datCoi);

  parameter Modelica.Units.SI.TemperatureDifference dTHys(
    final min=0)=0.5
    "Temperature comparison hysteresis difference"
    annotation(Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput XOut(
    final unit="kg/kg",
    final displayUnit="kg/kg",
    final quantity="MassFraction")
    "Outside air humidity ratio per kg of total air"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
      iconTransformation(extent={{-120,60},{-100,80}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostTimeCalculations
    defTimFra(
    final defTri=datCoi.defTri,
    final tDefRun=datCoi.tDefRun,
    final TDefLim=datCoi.TDefLim,
    final dTHys=dTHys)
    "Block to compute defrost time fraction, heat transfer multiplier and input power multiplier"
    annotation (Placement(transformation(extent={{0,90},{20,110}})));

  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilDefrostCapacity defCap(
    redeclare package MediumA = Medium,
    final defTri=datCoi.defTri,
    final defOpe=datCoi.defOpe,
    final tDefRun=datCoi.tDefRun,
    final defCur=datCoi,
    final QDefResCap=datCoi.QDefResCap)
    "Block to compute actual heat transferred to medium and power input after accounting for defrost"
    annotation (Placement(transformation(extent={{62,76},{82,96}})));


protected
  Modelica.Blocks.Sources.RealExpression p_in(
    final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,-30},{-70,-10}})));

  Modelica.Blocks.Sources.RealExpression X(
    final y=XIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));

equation
  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-46,62},{-46,52},{-21,52}},
                         color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-40,28},{-40,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut, defTimFra.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,
          62},{-46,62},{-46,102},{-1,102}},
                          color={0,0,127}));
  connect(defTimFra.tDefFra, defCap.tDefFra) annotation (Line(points={{21,104},{
          40,104},{40,97},{61,97}},        color={0,0,127}));
  connect(defTimFra.heaCapMul, defCap.heaCapMul) annotation (Line(points={{21,100},
          {34,100},{34,94},{61,94}},        color={0,0,127}));
  connect(defTimFra.inpPowMul, defCap.inpPowMul) annotation (Line(points={{21,96},
          {28,96},{28,91},{61,91}},         color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-40,28},{-40,88},
          {61,88}},  color={0,0,127}));
  connect(XOut, defTimFra.XOut) annotation (Line(points={{-110,70},{-52,70},{-52,
          98},{-1,98}},   color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot_flow) annotation (Line(points={{1,56},{22,56},
          {22,72},{61,72}},       color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,75},
          {61,75}},       color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,62},
          {-46,62},{-46,78},{61,78}},
                     color={0,0,127}));
  connect(defCap.QTotDef_flow, q.Q_flow) annotation (Line(points={{83,78},{94,78},
          {94,10},{32,10},{32,54},{42,54}},      color={0,0,127}));
  connect(defCap.QTotDef_flow, QSen_flow) annotation (Line(points={{83,78},{98,78},
          {98,70},{110,70}},      color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{83,90},{110,90}},
                color={0,0,127}));
  connect(p_in.y, defCap.pIn) annotation (Line(points={{-69,-20},{-30,-20},{-30,
          81},{61,81}},   color={0,0,127}));
  connect(X.y, defCap.XConIn) annotation (Line(points={{-69,12},{-36,12},{-36,84},
          {61,84}},       color={0,0,127}));
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
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={             Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen"),
                   Text(
          extent={{-158,98},{-100,80}},
          textColor={0,0,127},
          textString="XOut")}),
    Diagram(coordinateSystem(extent={{-100,-60},{100,120}})));
end PartialDXHeatingCoil;
