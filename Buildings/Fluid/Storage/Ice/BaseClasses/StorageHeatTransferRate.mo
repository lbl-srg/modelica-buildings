within Buildings.Fluid.Storage.Ice.BaseClasses;
model StorageHeatTransferRate
  "Charging or discharging rate based on the curves"
  parameter Real coeCha[6]={5.54E-05,-0.000145679,9.28E-05,0.001126122,-0.0011012,0.000300544}
    "Coefficients for charging curve";
  parameter Real dtCha=15 "Time step of curve fitting data";

  parameter Real coeDisCha[6]={5.54E-05,-0.000145679,9.28E-05,0.001126122,-0.0011012,0.000300544}
    "Coefficients for discharging curve";
  parameter Real dtDisCha=15 "Time step of curve fitting data";

  Buildings.Fluid.Storage.Ice.BaseClasses.QStarCharging qStaCha(
    coeff=coeCha,
    dt=dtCha)
    "q* for charing mode"
    annotation (Placement(transformation(extent={{-40,-34},{-20,-14}})));
  Buildings.Fluid.Storage.Ice.BaseClasses.QStarDischarging qStaDisCha(
    coeff=coeDisCha,
    dt=dtDisCha) "q* for discharging mode"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Blocks.Logical.Switch swi1 "Switch"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Constant of zero"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Modelica.Blocks.Logical.Switch swi2 "Switch"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Interfaces.RealOutput qNor(final quantity="1/s")
    "Normalized heat transfer rate: charging when postive, discharge when negative"
                                    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}),           iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput fraCha "Fraction of charge in ice tank"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput lmtdSta "LMTD star"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.IntegerInput u "Ice storage operation mode"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal isDor "Is dormant mode"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));

  Modelica.Blocks.Math.Gain gai(k=-1) "Gain"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal isCha "Is charging mode"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.IntegerExpression chaMod(
    y=Integer(Buildings.Fluid.Storage.Ice.Types.IceThermalStorageMode.Charging))
    "Charging mode"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.IntegerExpression dorMod(
    y=Integer(Buildings.Fluid.Storage.Ice.Types.IceThermalStorageMode.Dormant))
    "Dormant mode"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(zer.y, swi1.u1)
    annotation (Line(points={{41,40},{52,40},{52,8},{68,8}}, color={0,0,127}));
  connect(qStaCha.qNor, swi2.u1)
    annotation (Line(points={{-19,-24},{10,-24},{10,-42},{38,-42}},
                                                            color={0,0,127}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{61,-50},{64,-50},{64,-8},{68,-8}},
                                                             color={0,0,127}));
  connect(qStaCha.lmtdSta, lmtdSta) annotation (Line(points={{-42,-28},{-50,-28},
          {-50,-60},{-120,-60}},color={0,0,127}));
  connect(lmtdSta, qStaDisCha.lmtdSta) annotation (Line(points={{-120,-60},{-50,
          -60},{-50,-84},{-42,-84}}, color={0,0,127}));
  connect(isDor.y, swi1.u2) annotation (Line(points={{-18,80},{10,80},{10,0},{
          68,0}}, color={255,0,255}));
  connect(gai.y, swi2.u3) annotation (Line(points={{21,-80},{26,-80},{26,-58},{38,
          -58}},color={0,0,127}));
  connect(qStaDisCha.qNor,gai. u)
    annotation (Line(points={{-19,-80},{-2,-80}}, color={0,0,127}));
  connect(swi1.y, qNor) annotation (Line(points={{91,0},{110,0}},
        color={0,0,127}));
  connect(fraCha, qStaDisCha.fraCha) annotation (Line(points={{-120,0},{-70,0},{
          -70,-76},{-42,-76}},  color={0,0,127}));
  connect(fraCha, qStaCha.fraCha) annotation (Line(points={{-120,0},{-70,0},{-70,
          -20},{-42,-20}}, color={0,0,127}));
  connect(u, isDor.u1) annotation (Line(points={{-120,60},{-90,60},{-90,80},{
          -42,80}}, color={255,127,0}));
  connect(chaMod.y, isCha.u2) annotation (Line(points={{-59,30},{-50,30},{-50,
          42},{-42,42}}, color={255,127,0}));
  connect(u, isCha.u1) annotation (Line(points={{-120,60},{-90,60},{-90,50},{
          -42,50}}, color={255,127,0}));
  connect(dorMod.y, isDor.u2) annotation (Line(points={{-59,60},{-50,60},{-50,
          72},{-42,72}}, color={255,127,0}));
  connect(isCha.y, swi2.u2) annotation (Line(points={{-18,50},{0,50},{0,-50},{
          38,-50}}, color={255,0,255}));
  annotation (defaultComponentName = "norQSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-148,150},{152,110}},
        textString="%name",
        lineColor={0,0,255})}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This blocks calculate the normalized heat transfer rate for the ice tank under all operation modes: dormant, charging or discharging.
</p>

<p>The module use the following logic:</p>

<ul>
<li>Dormant Mode: the heat transfer rate is 0</li>
<li>Discharging Mode: the heat transfer rate is the discharging rate calculated 
        using <a href=\"modelica://IceStorage.BaseClasses.QStarDischarging\">IceStorage.BaseClasses.QStarDischarging</a> with calibrated coefficients for discharing mode
</li>
<li>Charging Mode: the heat transfer rate is the charging rate calculated 
        using <a href=\"modelica://IceStorage.BaseClasses.QStarCharging\">IceStorage.BaseClasses.QStarCharging</a> with calibrated coefficients for charing mode
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
December 8, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end StorageHeatTransferRate;
