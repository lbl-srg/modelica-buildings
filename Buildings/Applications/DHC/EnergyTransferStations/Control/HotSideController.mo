within Buildings.Applications.DHC.EnergyTransferStations.Control;
block HotSideController
  "State machine controls the operation of the heating generating source (EIR chiller)
   , two way heating valve, borfield and district pumps"
  extends Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HotColdSideController(
        THys=THys);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput reqHea
    "True if heating is required from heating generating source, false otherwise."
    annotation (
      Placement(transformation(extent={{140,128},{160,148}}),
                                                            iconTransformation(
          extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    annotation (Placement(transformation(extent={{-96,-110},{-76,-90}})));
equation
  connect(min.u1, TTop) annotation (Line(points={{-98,-94},{-120,-94},{-120,60},
          {-160,60}}, color={0,0,127}));
  connect(TTop, greEqu.u2) annotation (Line(points={{-160,60},{-120,60},{-120,32},
          {-102,32}}, color={0,0,127}));
  connect(TTop, greEqu5.u2) annotation (Line(points={{-160,60},{-120,60},{-120,
          -160},{-70,-160},{-70,-148},{-62,-148}}, color={0,0,127}));
  connect(min.u2, TBot) annotation (Line(points={{-98,-106},{-112,-106},{-112,-60},
          {-160,-60}}, color={0,0,127}));
  connect(TBot, greEqu1.u1) annotation (Line(points={{-160,-60},{-112,-60},{-112,18},
          {-66,18},{-66,8},{-62,8}}, color={0,0,127}));
  connect(TBot, greEqu2.u1) annotation (Line(points={{-160,-60},{-112,-60},{-112,
          18},{-66,18},{-66,-22},{-62,-22}}, color={0,0,127}));
  connect(TBot, greEqu3.u2) annotation (Line(points={{-160,-60},{-112,-60},{-112,
          18},{-66,18},{-66,-68},{-62,-68}}, color={0,0,127}));
  connect(min.y, greEqu4.u1) annotation (Line(points={{-74,-100},{-70,-100},{-70,
          -110},{-62,-110}},     color={0,0,127}));
  connect(runHP.active, reqHea) annotation (Line(points={{6,109},{6,106},{24,
          106},{24,138},{150,138}}, color={255,0,255}));
  connect(rejFulLoaSta.active, rejFulLoa)  annotation (Line(points={{56,49},{56,-48},{150,-48}}, color={255,0,255}));
  connect(rejFulLoaSta.active, or2.u1) annotation (Line(points={{56,49},{56,-80},{58,-80}}, color={255,0,255}));

   annotation ( Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
                    defaultComponentName="conHotSid",
                    Diagram(coordinateSystem(extent={{-140,-180},{140,160}})),
Documentation(info="<html>
<p>
This block is a state machine controller which transitions the hot and ambient water circuits in
<a href=\"Buildings.Applications.DHC.EnergyTransferStations.Substation\">
Buildings.Applications.DHC.EnergyTransferStations.Substation</a>
between different states i.e. operational modes. It generates the control signals for:
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
The finite state machines as illustrated in the figure below generates
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
Added the the documentation.
</li>
</ul>
</html>"));
end HotSideController;
