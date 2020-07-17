within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block RejectionMode "Selection of heat or cold rejection mode"
  extends Modelica.Blocks.Icons.Block;

  Buildings.Controls.OBC.CDL.Continuous.Greater heaRejDemDom
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not noHeaDem
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not noCooDem
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));
  Buildings.Controls.OBC.CDL.Logical.And cooOnl
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.And heaOnl
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCoo
    annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCooHeaDom
    annotation (Placement(transformation(extent={{10,90},{30,110}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaRejRaw
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold heaRejHol(trueHoldDuration=
        300, falseHoldDuration=0)
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not notColRej
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={140,50})));
  Buildings.Controls.OBC.CDL.Logical.Or colRejRaw
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold colRej(trueHoldDuration=300,
      falseHoldDuration=0)
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.And heaCooColDom
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.And HeaRej
    annotation (Placement(transformation(extent={{150,90},{170,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not colRejDemDom
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
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
    "Difference between maximum CHW tank temperature and set point" annotation
    (Placement(transformation(extent={{-240,-100},{-200,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yHeaRej
    "Heat rejection mode" annotation (Placement(transformation(extent={{200,20},
            {240,60}}), iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yColRej
    "Cold rejection mode" annotation (Placement(transformation(extent={{200,-60},
            {240,-20}}), iconTransformation(extent={{100,-70},{140,-30}})));
equation
  connect(noHeaDem.y,cooOnl. u1)
    annotation (Line(points={{-138,80},{-102,80}}, color={255,0,255}));
  connect(noCooDem.y,heaOnl. u2) annotation (Line(points={{-138,40},{-130,40},{
          -130,32},{-102,32}}, color={255,0,255}));
  connect(heaCooHeaDom.y, heaRejRaw.u1)
    annotation (Line(points={{32,100},{58,100}}, color={255,0,255}));
  connect(cooOnl.y,heaRejRaw. u2) annotation (Line(points={{-78,80},{50,80},{50,
          92},{58,92}},         color={255,0,255}));
  connect(heaRejRaw.y, heaRejHol.u)
    annotation (Line(points={{82,100},{98,100}}, color={255,0,255}));
  connect(colRejRaw.y, colRej.u)
    annotation (Line(points={{82,0},{98,0}}, color={255,0,255}));
  connect(heaCooColDom.y, colRejRaw.u1)
    annotation (Line(points={{32,0},{58,0}}, color={255,0,255}));
  connect(heaOnl.y,colRejRaw. u2) annotation (Line(points={{-78,40},{40,40},{40,
          -8},{58,-8}},         color={255,0,255}));
  connect(heaCoo.y, heaCooColDom.u1) annotation (Line(points={{-28,100},{-20,
          100},{-20,0},{8,0}}, color={255,0,255}));
  connect(heaRejDemDom.y, colRejDemDom.u) annotation (Line(points={{-138,-40},{
          -120,-40},{-120,-20},{-102,-20}}, color={255,0,255}));
  connect(colRejDemDom.y, heaCooColDom.u2) annotation (Line(points={{-78,-20},{
          -20,-20},{-20,-8},{8,-8}}, color={255,0,255}));
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
  connect(dTChiWat, heaRejDemDom.u1) annotation (Line(points={{-220,-80},{-180,
          -80},{-180,-40},{-162,-40}}, color={0,0,127}));
  connect(dTHeaWat, heaRejDemDom.u2) annotation (Line(points={{-220,-40},{-190,
          -40},{-190,-48},{-162,-48}}, color={0,0,127}));
  connect(heaCoo.y, heaCooHeaDom.u1)
    annotation (Line(points={{-28,100},{8,100}}, color={255,0,255}));
  connect(heaRejDemDom.y, heaCooHeaDom.u2) annotation (Line(points={{-138,-40},
          {0,-40},{0,92},{8,92}}, color={255,0,255}));
  connect(heaRejHol.y, HeaRej.u1)
    annotation (Line(points={{122,100},{148,100}}, color={255,0,255}));
  connect(colRej.y, notColRej.u)
    annotation (Line(points={{122,0},{140,0},{140,38}}, color={255,0,255}));
  connect(notColRej.y, HeaRej.u2)
    annotation (Line(points={{140,62},{140,92},{148,92}}, color={255,0,255}));
  connect(colRej.y, yColRej) annotation (Line(points={{122,0},{140,0},{140,-40},
          {220,-40}}, color={255,0,255}));
  connect(HeaRej.y, yHeaRej) annotation (Line(points={{172,100},{180,100},{180,
          40},{220,40}}, color={255,0,255}));
  connect(uHea, heaOnl.u1) annotation (Line(points={{-220,100},{-120,100},{-120,
          40},{-102,40}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-120},{200,
            120}})));
end RejectionMode;
