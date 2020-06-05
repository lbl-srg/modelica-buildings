within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block HotSide_state
  "State machine enabling production and ambient source systems"
  extends BaseClasses.HotColdSide_state;
  Buildings.Controls.OBC.CDL.Continuous.Min min
    annotation (Placement(transformation(extent={{-96,-110},{-76,-90}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-98,-94},{-168,-94},{-168,-40},
          {-200,-40}},color={0,0,127}));
  connect(TTop, enaHeaCoo.u2) annotation (Line(points={{-200,-40},{-166,-40},{
          -166,32},{-142,32}},
                          color={0,0,127}));
  connect(TTop, cloIso.u2) annotation (Line(points={{-200,-40},{-166,-40},{-166,
          -160},{-70,-160},{-70,-148},{-42,-148}}, color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-98,-106},{-112,-106},{-112,
          -120},{-200,-120}},
                       color={0,0,127}));
  connect(TBot, opeIso.u1) annotation (Line(points={{-200,-120},{-152,-120},{-152,
          -40},{-92,-40}}, color={0,0,127}));
  connect(TBot, enaRej.u1) annotation (Line(points={{-200,-120},{-172,-120},{-172,
          -180},{-52,-180},{-52,-200},{-42,-200}}, color={0,0,127}));
  connect(TBot, disRej.u2) annotation (Line(points={{-200,-120},{-172,-120},{
          -172,-260},{-60,-260},{-60,-248},{-42,-248}},
                                                   color={0,0,127}));
  connect(min.y, disHeaCoo.u1) annotation (Line(points={{-74,-100},{-40,-100},{
          -40,22},{-152,22},{-152,0},{-142,0}},
                                            color={0,0,127}));
  connect(run.active, yHeaCoo) annotation (Line(points={{-30,169},{-30,160},{
          200,160}},
                 color={255,0,255}));

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
end HotSide_state;
