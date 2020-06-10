within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
model ColdSide "State machine enabling production and ambient source systems"
  extends BaseClasses.HotColdSide(
    final reverseActing=true);
  Buildings.Controls.OBC.CDL.Continuous.Max max "Max"
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
equation
  connect(max.u2, TBot) annotation (Line(points={{-112,-86},{-140,-86},{-140,-140},
          {-200,-140}},     color={0,0,127}));
  connect(max.y, errDis.u2) annotation (Line(points={{-88,-80},{-80,-80},{-80,-12}},
                 color={0,0,127}));
  connect(TBot, errEna.u2) annotation (Line(points={{-200,-140},{-140,-140},{-140,
          20},{-100,20},{-100,28}},      color={0,0,127}));
  connect(TTop, max.u1) annotation (Line(points={{-200,-80},{-120,-80},{-120,
          -74},{-112,-74}}, color={0,0,127}));
  connect(TTop, conPlaSeq.u_m) annotation (Line(points={{-200,-80},{-120,-80},{
          -120,-140},{-100,-140},{-100,-132}}, color={0,0,127}));
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
