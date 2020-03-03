within Buildings.Applications.DHC.EnergyTransferStations.Controls;
model ColdSide "State machine controls the operation of the cooling generating source 
  (EIR chiller), two way cooling valve, borfield and district pumps"
  extends
    Buildings.Applications.DHC.EnergyTransferStations.Controls.BaseClasses.HotColdSide(
    THys=THys,
    redeclare model Inequality =
  Buildings.Controls.OBC.CDL.Continuous.LessEqual,
          addPar(p=-2*THys),
          addPar1(p=-THys),
          addPar2(p=-THys),
          addPar3(p=-0.5*THys));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqCoo
    "True if cooling is required from cooling generating source, false otherwise."
    annotation (Placement(
        transformation(extent={{140,132},{160,152}}),
                                                    iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController frePro(bandwidth=1)
    "Freeze protection override"
    annotation (Placement(transformation(extent={{50,-38},{70,-18}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=273.15 + 3.5)
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{88,-30},{108,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
equation
  connect(runHP.active, reqCoo) annotation (Line(points={{6,109},{6,108},{24,
          108},{24,142},{150,142}},color={255,0,255}));
  connect(con.y, frePro.reference) annotation (Line(points={{32,-10},{40,-10},{
          40,-22},{48,-22}}, color={0,0,127}));
  connect(or1.u2, frePro.y) annotation (Line(points={{86,-28},{72,-28}}, color={255,0,255}));
  connect(or1.u1, rejFulLoaSta.active) annotation (Line(points={{86,-20},{76,-20},
          {76,12},{56,12},{56,49}}, color={255,0,255}));
  connect(or1.y, rejFulLoa) annotation (Line(points={{110,-20},{116,-20},{116,20},
          {160,20}},  color={255,0,255}));
  connect(or1.y, or2.u1) annotation (Line(points={{110,-20},{116,-20},{116,-48},
          {40,-48},{40,-20},{58,-20}}, color={255,0,255}));
  connect(yVal,booToRea. y) annotation (Line(points={{160,-100},{122,-100}},
                     color={0,0,127}));
  connect(valSta,or2. y)  annotation (Line(points={{160,-20},{142,-20},{142,40},
          {122,40},{122,-20},{82,-20}},                                 color={255,0,255}));
  connect(or2.u2, rejParLoaSta.active) annotation (Line(points={{58,-28},{-6,-28},
          {-6,69}},                                                                         color={255,0,255}));
  connect(booToRea.u,or2. y) annotation (Line(points={{98,-100},{90,-100},{90,-20},
          {82,-20}},      color={255,0,255}));
  connect(or1.y,or2. u1) annotation (Line(points={{110,-20},{116,-20},{116,-48},
          {40,-48},{40,-20},{58,-20}}, color={255,0,255}));
  connect(max.u1, TTop) annotation (Line(points={{-102,-94},{-112,-94},{-112,60},
          {-160,60}}, color={0,0,127}));
  connect(frePro.u, TTop) annotation (Line(points={{48,-34},{44,-34},{44,-44},{
          -66,-44},{-66,22},{-112,22},{-112,60},{-160,60}}, color={0,0,127}));
  connect(TTop, greEqu1.u1) annotation (Line(points={{-160,60},{-112,60},{-112,22},{-66,
          22},{-66,8},{-62,8}}, color={0,0,127}));
  connect(TTop, greEqu2.u1) annotation (Line(points={{-160,60},{-112,60},{-112,
          22},{-66,22},{-66,-22},{-62,-22}}, color={0,0,127}));
  connect(TTop, greEqu3.u2) annotation (Line(points={{-160,60},{-112,60},{-112,
          22},{-66,22},{-66,-68},{-62,-68}}, color={0,0,127}));
  connect(max.y, greEqu4.u1) annotation (Line(points={{-78,-100},{-70,-100},{-70,
          -92},{-62,-92}},       color={0,0,127}));
  connect(max.u2, TBot) annotation (Line(points={{-102,-106},{-120,-106},{-120,
          -60},{-160,-60}}, color={0,0,127}));
  connect(TBot, greEqu5.u2) annotation (Line(points={{-160,-60},{-120,-60},{-120,
          -160},{-70,-160},{-70,-148},{-62,-148}}, color={0,0,127}));
  connect(TBot, greEqu.u2) annotation (Line(points={{-160,-60},{-120,-60},{-120,
          32},{-102,32}}, color={0,0,127}));
  annotation (
  defaultComponentName="conColSid",
  Diagram(coordinateSystem(extent={{-140,-160},{140,160}}), graphics={Text(
          extent={{-36,-32},{40,-40}},
          lineColor={28,108,200},
          textString="reject full load if tank exceeds setpoint by 3*THys",
          horizontalAlignment=TextAlignment.Left)}),
          Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<p>
This block is a state machine controller which transitions the chilled and ambient water circuits in
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Substation\">
Buildings.Applications.DHC.EnergyTransferStations.Substation</a>
between different states i.e. operational modes.It generates the control signals for:
</p>
<ul>
  <li>
  Cooling generation source i.e. EIR chiller/ heat pump.
  </li>
  <li>
  The borefield system.
  </li>
  <li>
  The district heat exchanger system.
  </li>
</ul>
<h4> Controller elaboration</h4>
<p>
The finite state machines as illustrated in the figure below generates
</p>
<ol>
  <li>
  The Boolean output signal <code>reqCoo</code>, true when the bottom level water temperature
  of the cold buffer tank <code>T<sub>Bot</sub></code> is higher than or equal to the
  cooling setpoint temperature <code>T<sub>Set</sub></code>. It indicates that the cooling
  generating source i.e. EIR chiller/heat pump switches on.
  </li>
  <li>
  The Boolean/real output signals <code>valSta</code>, true when the top level water
  temperature of the cold buffer tank <code>T<sub>Top</sub></code> is lower than the
  cooling setpoint temperature <code>T<sub>Set</sub></code> minus the defined hysteresis.
  It indicates that the partial rejection of surplus cooling energy to the borefield
  is required. It results in the start of the borefield pump i.e. switched On while
  the mass flow rate is modulated by a reverse action PI controller.
  </li>
  <li>
  The Boolean output signal <code>rejFulHexBor</code>, true when the top level water
  temperature of the cold buffer tank <code>T<sub>Top</sub></code> is lower than
  or equal to the cooling setpoint temperature <code>T<sub>Set</sub></code> minus the
  defined hysteresis. It indicates that a full rejection of surplus heat to either or both
  of the borefield and district heat exchanger system is required. It results that,
  i) the borefield pump runs on its maximum flow rate, ii)The district heat exchanger
   pump switches on
  </li>
</ol>
<p align= \"center\">
<img alt=\"State finite machine for the hot side\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/colTanCon.png\"/>
</p>
<p>
The table clarifies the states and associated actions
</p>
<table class=\"releaseTable\" summary=\"summary\" border=\"1\" cellspacing=0 cellpadding=2>
     <tr><td align=\"center\"><b>State</b>
        </td>
        <td align=\"center\"><b>Action</b>
        </td>
        </tr>
    <tr><td align=\"center\">reqCoo:true
        </td>
        <td align=\"center\">Cooling generation:On
        </td>
        </tr>
    <tr><td align=\"center\">rejCooParLoa:true
        </td>
        <td align=\"center\">yVal:true, BorPum:On with modulated flow rate.
        </td>
        </tr>
    <tr><td align=\"center\">rejCooFulLoa:true
        </td>
        <td align=\"center\">yVal:true, BorPum:On with maximum flow rate, DisPum:On with modulated flow rate.
        </td>
        </tr>
        </table>
<h4>Note</h4>
<ul>
  <li>
  The parameter &Delta;T is the implemented hysteresis to transit from state to another.
  </li>
  <li>
  An on-off override controller used to start the full load rejection once the water inside
  the tank reaches 3.5degC to avoid freezing.
  </li>
</ul>
</html>", revisions="<html>
<ul>
<li>
November 29, 2019, by Hagar Elarga:<br/>
Added the the documentation.
</li>
</ul>
</html>"));
end ColdSide;
