within Buildings.Fluid.Storage.Plant.Validation;
model WithRemoteCharging
  "(Draft) Validation model of the plant allowing remote charging"
  extends Modelica.Icons.Example;
  extends
    Buildings.Fluid.Storage.Plant.Validation.BaseClasses.PartialTankBranch(
      tanBra(final allowRemoteCharging=true),
      souChi(final use_m_flow_in=true));

  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,
        -1; 3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7
        *6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={0,3600/7*6}, startValue=
        true) "Tank is being charged remotely"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.BooleanTable uOnl(table={3600/7*2})
    "True = plant online (outputting CHW to the network); False = offline"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*5,1; 3600/7*5,0]) "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl
    conPumSecGro "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));
equation
  connect(set_mTan_flow.y, conPumSecGro.mTanSet_flow) annotation (Line(points={{-79,-30},
          {-70,-30},{-70,-2},{-61,-2}},          color={0,0,127}));
  connect(tanBra.mTan_flow, conPumSecGro.mTan_flow) annotation (Line(points={{
          11,2},{58,2},{58,98},{-78,98},{-78,2},{-61,2}}, color={0,0,127}));
  connect(tanBra.yPum, conPumSecGro.yPumSec)
    annotation (Line(points={{-11,2},{-39,2}}, color={0,0,127}));
  connect(conPumSecGro.yValCha, tanBra.yValCha)
    annotation (Line(points={{-39,6},{-11,6}}, color={0,0,127}));
  connect(tanBra.yValDis, conPumSecGro.yValDis)
    annotation (Line(points={{-11,10},{-39,10}}, color={0,0,127}));
  connect(uRemCha.y, conPumSecGro.uRemCha) annotation (Line(points={{-79,-60},{
          -58,-60},{-58,-10}},
                           color={255,0,255}));
  connect(uOnl.y, conPumSecGro.uOnl) annotation (Line(points={{-79,-90},{-54,-90},
          {-54,-10}}, color={255,0,255}));
  connect(tanBra.yValCha_actual, conPumSecGro.yValCha_actual) annotation (Line(
        points={{11,6},{54,6},{54,94},{-74,94},{-74,6},{-61,6}}, color={0,0,127}));
  connect(tanBra.yValDis_actual, conPumSecGro.yValDis_actual) annotation (Line(
        points={{11,10},{50,10},{50,90},{-70,90},{-70,10},{-61,10}}, color={0,0,
          127}));
  connect(set_mChi_flow.y, souChi.m_flow_in)
    annotation (Line(points={{21,70},{28,70},{28,42}}, color={0,0,127}));
  annotation (
  experiment(Tolerance=1e-06, StopTime=3600),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Plant/Validation/WithRemoteCharging.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
(Draft) This is a validation model where the plant is configured to allow
remotely charging the tank.
<p>
Operation modes implemented in time tables:
</p>
<table summary= \"operation modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th></th>
    <th>Plant</th>
    <th>Chiller</th>
    <th>Tank</th>
    <th>Flow direction</th>
    <th>Tank flow rate setpoint</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>1.</td>
    <td>off</td>
    <td>off</td>
    <td>off</td>
    <td>N/A</td>
    <td>0</td>
  </tr>
  <tr>
    <td>2.</td>
    <td>off</td>
    <td>on</td>
    <td>charging</td>
    <td>N/A</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>3.</td>
    <td>on</td>
    <td>on</td>
    <td>charging</td>
    <td>normal</td>
    <td>-1</td>
  </tr>
  <tr>
    <td>4.</td>
    <td>on</td>
    <td>on</td>
    <td>off</td>
    <td>normal</td>
    <td>0</td>
  </tr>
  <tr>
    <td>5.</td>
    <td>on</td>
    <td>on</td>
    <td>discharging</td>
    <td>normal</td>
    <td>1</td>
  </tr>
  <tr>
    <td>6.</td>
    <td>on</td>
    <td>off</td>
    <td>discharging</td>
    <td>normal</td>
    <td>1</td>
  </tr>
  <tr>
    <td>7.</td>
    <td>on</td>
    <td>off</td>
    <td>charging</td>
    <td>reverse</td>
    <td>-1</td>
  </tr>
</tbody>
</table>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end WithRemoteCharging;
