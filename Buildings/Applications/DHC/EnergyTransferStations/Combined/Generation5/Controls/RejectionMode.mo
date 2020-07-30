within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block RejectionMode "Selection of heat or cold rejection mode"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.TemperatureDifference dTDea(min=0) = 0.5
    "Temperature dead band (absolute value)";
  Buildings.Controls.OBC.CDL.Logical.Not noHeaDem "No heating demand"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not noCooDem "No cooling demand"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOnl "Cooling demand only"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.And heaOnl "Heating demand only"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCoo "Heating and cooling demand"
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCooHotDom
    "Heating and cooling demand with hot side error dominating"
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaRejMay
    "Heat rejection may be enabled"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not noColRej "Cold rejection disabled"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,50})));
  Buildings.Controls.OBC.CDL.Logical.Or colRej "Cold rejection enabled"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCooColDom
    "Heating and cooling demand with cold side error dominating"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.And HeaRej "Heat rejection enabled"
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not hotDom "Hot side error dominates"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "Cooling demand signal" annotation (Placement(transformation(extent={{-240,
            40},{-200,80}}), iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHea
    "Heating demand signal" annotation (Placement(transformation(extent={{-240,
            80},{-200,120}}), iconTransformation(extent={{-140,48},{-100,88}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dTHeaWat
    "Difference between set point and minimum HW tank temperature" annotation (
      Placement(transformation(extent={{-240,-60},{-200,-20}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dTChiWat
    "Difference between maximum CHW tank temperature and set point" annotation (
     Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaRej
    "Heat rejection enabled"
                          annotation (Placement(transformation(extent={{200,20},
            {240,60}}), iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yColRej
    "Cold rejection enabled"
                          annotation (Placement(transformation(extent={{200,-60},
            {240,-20}}), iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=-abs(dTDea), uHigh=
        abs(dTDea))
    "Hysteresis for demand comparison, true if cold side error dominates"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(k2=-1)
    "Difference between hot and cold side errors"
    annotation (Placement(transformation(extent={{-170,-70},{-150,-50}})));
equation
  connect(noHeaDem.y,cooOnl. u1)
    annotation (Line(points={{-138,80},{-102,80}}, color={255,0,255}));
  connect(noCooDem.y,heaOnl. u2) annotation (Line(points={{-138,40},{-130,40},{
          -130,32},{-102,32}}, color={255,0,255}));
  connect(heaCooHotDom.y,heaRejMay. u1)
    annotation (Line(points={{32,100},{58,100}}, color={255,0,255}));
  connect(cooOnl.y,heaRejMay. u2) annotation (Line(points={{-78,80},{50,80},{50,
          92},{58,92}},         color={255,0,255}));
  connect(heaCooColDom.y, colRej.u1)
    annotation (Line(points={{32,0},{58,0}}, color={255,0,255}));
  connect(heaOnl.y, colRej.u2) annotation (Line(points={{-78,40},{40,40},{40,-8},
          {58,-8}}, color={255,0,255}));
  connect(heaCoo.y, heaCooColDom.u1) annotation (Line(points={{-28,100},{-20,
          100},{-20,0},{8,0}}, color={255,0,255}));
  connect(uHea, noHeaDem.u) annotation (Line(points={{-220,100},{-180,100},{
          -180,80},{-162,80}}, color={255,0,255}));
  connect(uCoo, cooOnl.u2) annotation (Line(points={{-220,60},{-110,60},{-110,
          72},{-102,72}}, color={255,0,255}));
  connect(uHea, heaCoo.u1)
    annotation (Line(points={{-220,100},{-52,100}}, color={255,0,255}));
  connect(uCoo, noCooDem.u) annotation (Line(points={{-220,60},{-181,60},{-181,
          40},{-162,40}}, color={255,0,255}));
  connect(uCoo, heaCoo.u2) annotation (Line(points={{-220,60},{-60,60},{-60,92},
          {-52,92}}, color={255,0,255}));
  connect(heaCoo.y,heaCooHotDom. u1)
    annotation (Line(points={{-28,100},{8,100}}, color={255,0,255}));
  connect(noColRej.y, HeaRej.u2)
    annotation (Line(points={{140,62},{140,92},{148,92}}, color={255,0,255}));
  connect(HeaRej.y, yHeaRej) annotation (Line(points={{172,100},{180,100},{180,
          40},{220,40}}, color={255,0,255}));
  connect(uHea, heaOnl.u1) annotation (Line(points={{-220,100},{-120,100},{-120,
          40},{-102,40}}, color={255,0,255}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-148,-60},{-142,-60}}, color={0,0,127}));
  connect(dTHeaWat, add2.u1) annotation (Line(points={{-220,-40},{-180,-40},{-180,
          -54},{-172,-54}}, color={0,0,127}));
  connect(dTChiWat, add2.u2) annotation (Line(points={{-220,-80},{-180,-80},{-180,
          -66},{-172,-66}}, color={0,0,127}));
  connect(hys.y, hotDom.u) annotation (Line(points={{-118,-60},{-100,-60},{-100,
          0},{-82,0}}, color={255,0,255}));
  connect(hys.y, heaCooColDom.u2) annotation (Line(points={{-118,-60},{-20,-60},
          {-20,-8},{8,-8},{8,-8}}, color={255,0,255}));
  connect(hotDom.y, heaCooHotDom.u2) annotation (Line(points={{-58,0},{-40,0},{
          -40,60},{0,60},{0,92},{8,92}}, color={255,0,255}));
  connect(heaRejMay.y, HeaRej.u1)
    annotation (Line(points={{82,100},{148,100}}, color={255,0,255}));
  connect(colRej.y, noColRej.u)
    annotation (Line(points={{82,0},{140,0},{140,38}}, color={255,0,255}));
  connect(colRej.y, yColRej) annotation (Line(points={{82,0},{140,0},{140,-40},
          {220,-40}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{200,
            120}})),
    Documentation(info="<html>
<p>
This block computes the Boolean signals enabling heat and cold 
rejection in the supervisory control block
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory1\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Supervisory1</a>.
</p>
<p>
Cold rejection is enabled if
</p>
<ul>
<li>
there is a heating demand, with no simultaneous cooling demand, or
</li>
<li>
there is a simultaneous heating and cooling demand, and the temperature
difference (negative) representative of the demand for heat or cold rejection (see
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>)
is lower (higher in absolute value) for the chilled water tank than for 
the heating water tank.
</li>
</ul>
<p>
Heat rejection is enabled if
</p>
<ul>
<li>
there is a cooling demand, with no simultaneous heating demand, or
</li>
<li>
there is a simultaneous heating and cooling demand, and the temperature
difference (negative) representative of the demand for heat or cold rejection (see
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.BaseClasses.PartialSideHotCold</a>)
is lower (higher in absolute value) for the heating water tank than for 
the chilled water tank, and cold rejection is disabled.
</li>
</ul>
</html>"));
end RejectionMode;
