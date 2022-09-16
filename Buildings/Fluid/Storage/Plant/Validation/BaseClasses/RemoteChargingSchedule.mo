within Buildings.Fluid.Storage.Plant.Validation.BaseClasses;
partial model RemoteChargingSchedule
  "Schedules for validation models with remote charging"
  Modelica.Blocks.Sources.BooleanTable uAva(table={3600/7*2})
    "True = plant is available; False = unavailable"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanTable uRemCha(table={0,3600/7*6}, startValue=true)
              "Tank is being charged remotely"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Sources.TimeTable set_mTan_flow(table=[0,0; 3600/7,0; 3600/7,-1;
        3600/7*3,-1; 3600/7*3,0; 3600/7*4,0; 3600/7*4,1; 3600/7*6,1; 3600/7*6,-1])
            "Tank flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.TimeTable set_mChi_flow(table=[0,0; 3600/7,0; 3600/7,
        1; 3600/7*2,1; 3600/7*2,2; 3600/7*3,2; 3600/7*3,1; 3600/7*5,1; 3600/7*5,
        0])                         "Chiller flow rate setpoint"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Fluid.Storage.Plant.Controls.RemoteCharging conRemCha
    "Control block for the secondary pump and near-by valves"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
equation
  connect(uRemCha.y,conRemCha. uRemCha) annotation (Line(points={{-39,70},{34,
          70},{34,58},{32,58}},
                            color={255,0,255}));
  connect(uAva.y,conRemCha.uAva)  annotation (Line(points={{-79,90},{38,90},{38,
          54},{32,54}}, color={255,0,255}));
  connect(conRemCha.mTanSet_flow, set_mTan_flow.y) annotation (Line(points={{9,58},{
          -60,58},{-60,50},{-79,50}},  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
        Documentation(info="<html>
<p>
This partial model contains the following schedules for a storage plant
that allows remote charging.
</p>
<table summary= \"operation modes\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Time slot</th>
    <th>Plant flow</th>
    <th>Chiller flow</th>
    <th>Tank flow</th>
    <th>Plant flow direction</th>
    <th>Description</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>1.</td>
    <td>0</td>
    <td>0</td>
    <td>0</td>
    <td>No flow</td>
    <td>Plant closed and disconnected from network</td>
  </tr>
  <tr>
    <td>2.</td>
    <td>0</td>
    <td>1</td>
    <td>-1</td>
    <td>No flow</td>
    <td>Plant disconnected fron the network;<br/>
        Tank charged by local chiller</td>
  </tr>
  <tr>
    <td>3.</td>
    <td>1</td>
    <td>2</td>
    <td>-1</td>
    <td>Normal</td>
    <td>Chiller outputs to the network and charges the tank at the same time</td>
  </tr>
  <tr>
    <td>4.</td>
    <td>1</td>
    <td>1</td>
    <td>0</td>
    <td>Normal</td>
    <td>Chiller outputs to the network;<br/>
        Tank on hold (not charging nor discharging)</td>
  </tr>
  <tr>
    <td>5.</td>
    <td>2</td>
    <td>1</td>
    <td>1</td>
    <td>Normal</td>
    <td>Chiller and tank both outputting to the network</td>
  </tr>
  <tr>
    <td>6.</td>
    <td>1</td>
    <td>0</td>
    <td>1</td>
    <td>Normal</td>
    <td>Chiller off;<br/>
        Tank discharging to the network</td>
  </tr>
  <tr>
    <td>7.</td>
    <td>-1</td>
    <td>0</td>
    <td>-1</td>
    <td>Reverse</td>
    <td>Chiller off;<br/>
        Tank being charged by the network</td>
  </tr>
</tbody>
</table>
<p>
Notes:
</p>
<ul>
<li>
Mass balance: Plant flow = Chiller flow + Tank flow.
</li>
<li>
For the overall storage plant,
<ul>
<li>
A positive flow indicates that it is outputting CHW to the network;
</li>
<li>
And a negative flow indicates that its tank is being charged by the network,
i.e. the storage plant is functioning like a consumer.
</li>
</ul>
</li>
<li>
For the storage tank,
<ul>
<li>
A positive flow indicates it is discharging;
</li>
<li>
And a negative flow indicates it is being charged.
</li>
</ul>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 21, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end RemoteChargingSchedule;
