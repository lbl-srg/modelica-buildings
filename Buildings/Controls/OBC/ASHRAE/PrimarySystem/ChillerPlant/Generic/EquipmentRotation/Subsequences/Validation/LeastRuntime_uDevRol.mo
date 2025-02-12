within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Validation;
model LeastRuntime_uDevRol
  "Validate lead/lag and lead/standby switching signal based on least device runtime"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime
    leaRunTim(final lag=true)
    "Equipment rotation signal based on device runtime and current device status"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime
    leaRunTim1(final lag=false)
    "Equipment rotation signal based on device runtime and current device status"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime
    leaRunTim2(final lag=true)
    "Equipment rotation signal based on device runtime and current device status"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two
    rotTwo "Updates device roles based on the equipment rotation signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two
    rotTwo1 "Updates device roles based on the equipment rotation signal"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.Two
    rotTwo2 "Updates device roles based on the equipment rotation signal"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));

protected
  parameter Boolean initRoles[2] = {true, false}
    "Sets initial roles: true = lead, false = lag or standby";

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[2] "Switch"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi1[2] "Switch"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.CDL.Logical.Switch logSwi2[2] "Switch"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant staSta[2](
    final k=fill(false, 2)) "Standby status"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repLag1(final nout=2)
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repLag(final nout=2)
    "Replicates lag signal"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator repLead(final nout=2)
    "Replicates lead signal"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse leadLoad(
    final width=0.8,
    final period=7200) "Lead device enable status"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad(
    final width=0.2, final period=3600) "Lag device enable status"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse lagLoad1(
    final width=0.2, final period=5400) "Lag device enable status"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));

equation
  connect(leadLoad.y, repLead.u) annotation (Line(points={{-78,80},{-70,80},{-70,
          70},{-62,70}}, color={255,0,255}));
  connect(lagLoad.y, repLag.u) annotation (Line(points={{-78,30},{-70,30},{-70,40},
          {-62,40}}, color={255,0,255}));
  connect(repLead.y, logSwi.u1) annotation (Line(points={{-38,70},{-20,70},{-20,
          58},{-2,58}},color={255,0,255}));
  connect(repLag.y, logSwi.u3) annotation (Line(points={{-38,40},{-10,40},{-10,42},
          {-2,42}}, color={255,0,255}));
  connect(logSwi.y,leaRunTim. uDevSta)
    annotation (Line(points={{22,50},{38,50}}, color={255,0,255}));
  connect(logSwi1.y,leaRunTim1. uDevSta)
    annotation (Line(points={{22,0},{38,0}}, color={255,0,255}));
  connect(staSta.y,logSwi1. u3) annotation (Line(points={{-78,-10},{-40,-10},{-40,
          -8},{-2,-8}}, color={255,0,255}));
  connect(repLead.y,logSwi1. u1) annotation (Line(points={{-38,70},{-30,70},{-30,
          8},{-2,8}},   color={255,0,255}));
  connect(lagLoad1.y, repLag1.u)
    annotation (Line(points={{-78,-70},{-62,-70}}, color={255,0,255}));
  connect(repLead.y,logSwi2. u1) annotation (Line(points={{-38,70},{-30,70},{-30,
          -42},{-2,-42}}, color={255,0,255}));
  connect(repLag1.y,logSwi2. u3) annotation (Line(points={{-38,-70},{-30,-70},{-30,
          -58},{-2,-58}}, color={255,0,255}));
  connect(logSwi2.y,leaRunTim2. uDevSta)
    annotation (Line(points={{22,-50},{38,-50}}, color={255,0,255}));
  connect(leaRunTim.yRot, rotTwo.uRot)
    annotation (Line(points={{62,50},{78,50}}, color={255,0,255}));
  connect(rotTwo.yPreDevRolSig,leaRunTim. uPreDevRolSig) annotation (Line(points={{102,44},
          {108,44},{108,30},{30,30},{30,42},{38,42}},          color={255,0,255}));
  connect(rotTwo.yPreDevRolSig, logSwi.u2) annotation (Line(points={{102,44},{108,
          44},{108,30},{-20,30},{-20,50},{-2,50}},     color={255,0,255}));
  connect(leaRunTim1.yRot, rotTwo1.uRot)
    annotation (Line(points={{62,0},{78,0}}, color={255,0,255}));
  connect(leaRunTim2.yRot, rotTwo2.uRot)
    annotation (Line(points={{62,-50},{78,-50}}, color={255,0,255}));
  connect(rotTwo2.yPreDevRolSig,leaRunTim2. uPreDevRolSig) annotation (Line(points={{102,-56},
          {110,-56},{110,-70},{30,-70},{30,-58},{38,-58}},           color={255,
          0,255}));
  connect(rotTwo2.yPreDevRolSig, logSwi2.u2) annotation (Line(points={{102,-56},
          {110,-56},{110,-70},{-20,-70},{-20,-50},{-2,-50}}, color={255,0,255}));
  connect(rotTwo1.yPreDevRolSig,leaRunTim1. uPreDevRolSig) annotation (Line(points={{102,-6},
          {110,-6},{110,-20},{30,-20},{30,-8},{38,-8}},          color={255,0,
          255}));
  connect(rotTwo1.yPreDevRolSig, logSwi1.u2) annotation (Line(points={{102,-6},{
          110,-6},{110,-20},{-20,-20},{-20,0},{-2,0}},  color={255,0,255}));
          annotation (
   experiment(StopTime=100000.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/EquipmentRotation/Subsequences/Validation/LeastRuntime_uDevRol.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.EquipmentRotation.Subsequences.LeastRuntime</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2020, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}}),
        graphics={Text(
          extent={{-52,-104},{46,-114}},
          textColor={0,0,127},
          textString="For simplicity this test assumes 
the device ON/OFF status equals its setpoint 
(there is no delay in starting or stopping devices).")}));
end LeastRuntime_uDevRol;
