within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial model PartialDXHeatingCoil "Partial model for DX heating coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    final activate_CooCoi=false,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil dxCoi(
        redeclare package Medium = Medium),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol,
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCoi);

  CoilDefrostTimeCalculations defTim(defTri=defTri, tDefRun=tDefRun,
    TDefLim=TDefLim)
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  CoilDefrostCapacity defCap(
    defTri=defTri,
    defOpe=defOpe,
    tDefRun=tDefRun,
    defCur=defCur,
    redeclare package MediumA = Medium)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Modelica.Blocks.Interfaces.RealInput XOut(unit="kg/kg", displayUnit="kg/kg", quantity="MassFraction")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
    annotation (Placement(transformation(extent={{-120,4},{-100,24}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));

  replaceable
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    defCur constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Defrost
    annotation (Placement(transformation(extent={{54,-26},{74,-6}})));

  parameter DefrostOperation defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostOperation.resistive
    "Type of defrost method";
  parameter DefrostTriggers defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DefrostTriggers.timed
    "Type of method to trigger the defrost cycle";
  parameter Real tDefRun(
    final unit="1",
    displayUnit="1")=0.5
    "Time period for which defrost cycle is run";
  parameter Real PLFraFunPLR[:]={1}
    "Quadratic/cubic equation for part load fraction as a function of part-load ratio";
  parameter Modelica.Units.SI.ThermodynamicTemperature TDefLim=273.65
    "Maximum temperature at which defrost operation is activated";
equation
  connect(TOut,dxCoi.TEvaIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          52},{-21,52}}, color={0,0,127}));
  connect(T.y,dxCoi.TConIn)  annotation (Line(points={{-69,28},{-60,28},{-60,57},
          {-21,57}}, color={0,0,127}));
  connect(TOut,defTim. TOut) annotation (Line(points={{-110,30},{-92,30},{-92,-38},
          {29,-38}}, color={0,0,127}));
  connect(defTim.tFracDef, defCap.tFracDef) annotation (Line(points={{51,-36},{54.5,
          -36},{54.5,-41},{59,-41}}, color={0,0,127}));
  connect(defTim.heaCapMul, defCap.heaCapMul) annotation (Line(points={{51,-40},
          {54,-40},{54,-44},{59,-44}}, color={0,0,127}));
  connect(defTim.inpPowMul, defCap.inpPowMul) annotation (Line(points={{51,-44},
          {54,-44},{54,-47},{59,-47}}, color={0,0,127}));
  connect(T.y, defCap.TConIn) annotation (Line(points={{-69,28},{-34,28},{-34,-50},
          {59,-50}}, color={0,0,127}));
  connect(XOut,defTim. XOut) annotation (Line(points={{-110,14},{20,14},{20,-42},
          {29,-42}}, color={0,0,127}));
  connect(dxCoi.Q_flow, defCap.QTot) annotation (Line(points={{1,56},{22,56},{22,
          -66},{59,-66}},    color={0,0,127}));
  connect(dxCoi.EIR, defCap.EIR) annotation (Line(points={{1,60},{18,60},{18,
          -62},{59,-62}}, color={0,0,127}));
  connect(TOut, defCap.TOut) annotation (Line(points={{-110,30},{-92,30},{-92,-59},
          {59,-59}}, color={0,0,127}));
  connect(defCap.QTotDef, q.Q_flow) annotation (Line(points={{81,-58},{94,-58},{
          94,10},{32,10},{32,54},{42,54}}, color={0,0,127}));
  connect(defCap.QTotDef, QSen_flow) annotation (Line(points={{81,-58},{94,-58},
          {94,70},{110,70}}, color={0,0,127}));
  connect(defCap.PTot, P) annotation (Line(points={{81,-46},{82,-46},{82,90},{110,
          90}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedDXHeating\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.SingleSpeedDXHeating</a>.
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
