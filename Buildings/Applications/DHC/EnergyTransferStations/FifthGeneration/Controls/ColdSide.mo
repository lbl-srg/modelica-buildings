within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls;
model ColdSide "State machine controls the operation of the cooling generating source 
  (EIR chiller), two way cooling valve, borfield and district pumps"
  extends
    Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.Controls.BaseClasses.HotColdSide(
    THys=THys,
    redeclare model Inequality =
        Buildings.Controls.OBC.CDL.Continuous.LessEqual,
    addPar(p=-2*THys),
    addPar1(p=-THys),
    addPar2(p=-THys),
    addPar3(p=-0.5*THys));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yCoo
    "Cooling mode enabled signal" annotation (Placement(transformation(extent={{
            140,120},{180,160}}), iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Logical.OnOffController frePro(bandwidth=1)
    "Freeze protection override"
    annotation (Placement(transformation(extent={{50,-150},{70,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=273.15 + 3.5)
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    annotation (Placement(transformation(extent={{90,-110},{110,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
equation
  connect(run.active, yCoo) annotation (Line(points={{-30,169},{-30,106},{40,106},
          {40,140},{160,140}}, color={255,0,255}));
  connect(con.y, frePro.reference) annotation (Line(points={{52,-100},{60,-100},
          {60,-120},{40,-120},{40,-134},{48,-134}},
                             color={0,0,127}));
  connect(or1.u2, frePro.y) annotation (Line(points={{88,-108},{80,-108},{80,
          -140},{72,-140}},                                              color={255,0,255}));
  connect(or1.u1, rejFul.active) annotation (Line(points={{88,-100},{80,-100},{80,
          -80},{36,-80},{36,0},{80,0},{80,89}}, color={255,0,255}));
  connect(or1.y, yRej) annotation (Line(points={{112,-100},{130,-100},{130,20},{
          200,20}}, color={255,0,255}));
  connect(or2.u2, rejPar.active) annotation (Line(points={{88,-28},{-30,-28},{-30,
          109}}, color={255,0,255}));
  connect(or1.y,or2. u1) annotation (Line(points={{112,-100},{120,-100},{120,-48},
          {40,-48},{40,-20},{88,-20}}, color={255,0,255}));
  connect(max.u1, TTop) annotation (Line(points={{-102,-94},{-112,-94},{-112,-40},
          {-200,-40}},color={0,0,127}));
  connect(frePro.u, TTop) annotation (Line(points={{48,-146},{0,-146},{0,-40},{-66,
          -40},{-66,-44},{-112,-44},{-112,-40},{-200,-40}}, color={0,0,127}));
  connect(TTop, greEqu1.u1) annotation (Line(points={{-200,-40},{-112,-40},{-112,
          22},{-66,22},{-66,-60},{-92,-60}},
                                color={0,0,127}));
  connect(TTop, greEqu2.u1) annotation (Line(points={{-200,-40},{-112,-40},{-112,
          -18},{-66,-18},{-66,-100},{-92,-100}},
                                             color={0,0,127}));
  connect(TTop, greEqu3.u2) annotation (Line(points={{-200,-40},{-112,-40},{-112,
          -80},{-66,-80},{-66,-148},{-92,-148}},
                                             color={0,0,127}));
  connect(max.y, greEqu4.u1) annotation (Line(points={{-78,-100},{-70,-100},{-70,
          -180},{-92,-180}},     color={0,0,127}));
  connect(max.u2, TBot) annotation (Line(points={{-102,-106},{-120,-106},{-120,-120},
          {-200,-120}},     color={0,0,127}));
  connect(TBot, greEqu5.u2) annotation (Line(points={{-200,-120},{-120,-120},{-120,
          -160},{-70,-160},{-70,-228},{-92,-228}}, color={0,0,127}));
  connect(TBot, greEqu.u2) annotation (Line(points={{-200,-120},{-120,-120},{-120,
          -8},{-140,-8}}, color={0,0,127}));
  annotation (
  defaultComponentName="conCol",
Documentation(info="<html>
<p>
This is a controller which transitions the chilled and ambient water circuits in
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Substation\">
Buildings.Applications.DHC.EnergyTransferStations.Substation</a>
between different operating modes.
It generates the control signals for
</p>
<ul>
  <li>
  Cooling generation source i.e. chiller or heat pump.
  </li>
  <li>
  The borefield system.
  </li>
  <li>
  The district heat exchanger system.
  </li>
</ul>
<h4>Implementation</h4>
<p>
The control logic is modeled using a finite state machine as illustrated 
in the figure below.
</p>
<ol>
<li>
The Boolean output signal <code>yCoo</code> is true when the water temperature at the 
bottom of the buffer tank is higher than the chilled water supply temperature set-point.
This signal is used as the on/off command for the main chilled water production system.
</li>
<li>
The Boolean/real output signals <code>yIsoEva</code> is true when the water
temperature at the top of the buffer tank is lower than the
chilled water supply temperature set-point minus the defined hysteresis.
It indicates that partial rejection of excess cold is required.
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
Added documentation.
</li>
<li>
March 21, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ColdSide;
