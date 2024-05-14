within Buildings.Templates.Plants.Controls.Pumps.Primary.Validation;
model VariableSpeed
  "Validation model for the control logic of variable speed primary pumps"
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed
    ctlPumPriHdrHea(
    have_heaWat=true,
    have_chiWat=false,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8) "Headered primary pumps – Heating-only plant"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[0,0,0; 0.1,1,0; 0.5,1,1; 1,1,1; 1.5,1,1; 2,0,1; 2.5,0,0; 3,0,0],
    timeScale=300,
    period=900)
    "Command signal – Plant, equipment or isolation valve depending on tested configuration"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriHdr(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriHdr=true,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Headered primary pumps – Heating and cooling plant"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[2]
    "Opposite signal to generate cooling system commands"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed
    ctlPumPriDedCom(
    have_heaWat=true,
    have_chiWat=true,
    have_pumChiWatPriDed=false,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Common dedicated primary pumps – Heating and cooling plant"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed
    ctlPumPriDedSep(
    have_heaWat=true,
    have_chiWat=true,
    have_pumChiWatPriDed=true,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Separate dedicated primary pumps – Heating and cooling plant"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
equation
  connect(u1.y,ctlPumPriHdrHea. u1PumHeaWatPri) annotation (Line(points={{-58,0},
          {-40,0},{-40,68.5714},{18,68.5714}},
                                     color={255,0,255}));
  connect(u1.y, u1Coo.u)
    annotation (Line(points={{-58,0},{-32,0}}, color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdr.u1PumChiWatPri)
    annotation (Line(points={{-8,0},{0,0},{0,18.5714},{18,18.5714}},
                                                           color={255,0,255}));
  connect(u1.y, ctlPumPriHdr.u1PumHeaWatPri) annotation (Line(points={{-58,0},{
          -40,0},{-40,28.5714},{18,28.5714}},
                                color={255,0,255}));
  connect(u1.y, ctlPumPriDedCom.u1PumHeaWatPri) annotation (Line(points={{-58,0},
          {-40,0},{-40,-11.4286},{18,-11.4286}},
                                       color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedCom.u1Hea) annotation (Line(points={{-8,0},{0,0},
          {0,-20},{18,-20}}, color={255,0,255}));
  connect(u1.y, ctlPumPriDedSep.u1PumHeaWatPri) annotation (Line(points={{-58,0},
          {-40,0},{-40,-51.4286},{18,-51.4286}},color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSep.u1PumChiWatPri) annotation (Line(points={{-8,0},{
          0,0},{0,-61.4286},{18,-61.4286}},
                                      color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Primary/Validation/VariableSpeed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=900.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed\">
Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed</a>
with two plant equipment and two primary pumps and for the following configurations.
</p>
<ul>
<li>
Heating-only plant with headered primary pumps (component <code>ctlPumPriHdrHea</code>)
</li>
<li>
Heating and cooling plant with headered primary pumps (component <code>ctlPumPriHdr</code>)
</li>
<li>
Heating and cooling plant with common dedicated primary pumps (component <code>ctlPumPriDedCom</code>)
</li>
<li>
Heating and cooling plant with separate dedicated primary pumps (component <code>ctlPumPriDedSep</code>)
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added test for ∆p-controlled primary pumps.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end VariableSpeed;
