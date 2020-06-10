within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block HotSide "State machine enabling production and ambient source systems"
  extends BaseClasses.HotColdSide(
    final reverseActing=false,
    final have_yExt=false,
    mulMax(nin=nSouAmb));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    annotation (Placement(transformation(extent={{-110,-90},{-90,-70}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-112,-74},{-140,-74},{-140,-80},
          {-200,-80}},color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-112,-86},{-140,-86},{-140,-140},
          {-200,-140}},color={0,0,127}));

  connect(min.y, errDis.u2) annotation (Line(points={{-88,-80},{-80,-80},{-80,-12}},
                 color={0,0,127}));
  connect(TTop, errEna.u2) annotation (Line(points={{-200,-80},{-140,-80},{-140,
          20},{-100,20},{-100,28}}, color={0,0,127}));
  connect(TBot, conPlaSeq.u_m) annotation (Line(points={{-200,-140},{-100,-140},
          {-100,-132}},
                      color={0,0,127}));
  connect(conPlaSeq.y, mulMax.u)
    annotation (Line(points={{-88,-120},{18,-120}}, color={0,0,127}));
  connect(conPlaSeq.y, y) annotation (Line(points={{-88,-120},{26,-120},{26,-24},
          {144,-24},{144,0},{200,0}}, color={0,0,127}));
  connect(TSet, conPlaSeq.u_s) annotation (Line(points={{-200,120},{-200,-4},{
          -172,-4},{-172,-62},{-112,-62},{-112,-120}}, color={0,0,127}));
   annotation (
   defaultComponentName="conHot",
Documentation(info="<html>
<p>
This is a controller which transitions the hot and ambient water circuits in
between different states i.e. operating modes. 
It generates the control signals for
</p>
<ul>
  <li>
  Heating generation source i.e. EIR chiller/ heat pump.
  </li>
  <li>
  The borefield system.
  </li>
  <li>
  The district heat exchanger system.
  </li>
</ul>
<p>
The finite state machine as illustrated in the figure below generates
</p>
<ol>
  <li>
  The boolean output signal <code>reqHea</code>, true when the top level water temperature
  of the hot buffer tank <code>T<sub>Top</sub></code> is lower than or equal to the heating
  setpoint temperature <code>T<sub>Set</sub></code>. It indicates that the heating generating source
  i.e. EIR chiller/heat pump switches on.
  </li>
  <li>
  The boolean/real output signals <code>valSta</code>, true when the bottom level water
  temperature of the hot buffer tank <code>T<sub>Bot</sub></code> is higher than the heating
  setpoint temperature <code>T<sub>Set</sub></code> plus the defined hystresis.
  It indicates that a partial rejection of surplus heating energy to the the borefiled system
  is required. It results in the start of the borefield pump i.e. switched on while
  the mass flow rate is modulated by a reverse action PI controller.
  </li>
  <li>
  The boolean output signal <code>rejFulHexBor</code>, true
  when the bottom level water temperature of the hot buffer tank <code>T<sub>Bot</sub></code> is
  higher than or equal to the heating setpoint temperature <code>T<sub>Set</sub></code> plus the defined hystresis.
  It indicates that a full rejection of surplus heat to either or both of the borefield and
  district system is required.It results that,
  i) the borefield pump runs on its maximum flow rate, ii) the district heat exchanger
      pump switches on
  </li>
</ol>
<h4>Note</h4>
<p>
The parameter &Delta;T is the implemented hystresis to transit from a state to another.
</p>
<p align= \"center\">
<img alt=\"State finite machine for the hot side\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/hotTanCon.png\"/>
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
    <tr><td align=\"center\">reqHea:true
        </td>
        <td align=\"center\">Heating generating:On
        </td>
        </tr>
    <tr><td align=\"center\">rejHeaParLoa:true
        </td>
        <td align=\"center\">yVal:true, BorPum:On with modulated flow rate.
        </td>
        </tr>
    <tr><td align=\"center\">rejHeaFulLoa:true
        </td>
        <td align=\"center\">yVal:true, BorPum:On with maximum flow rate, DisPum:On with modulated flow rate.
        </td>
        </tr>
</table>

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
end HotSide;
