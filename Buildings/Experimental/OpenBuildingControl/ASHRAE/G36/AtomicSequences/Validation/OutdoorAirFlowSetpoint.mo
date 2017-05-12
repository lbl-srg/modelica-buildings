within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.Validation;
model OutdoorAirFlowSetpoint
  extends Modelica.Icons.Example;
  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences.OutdoorAirFlowSetpoint
    outdoorAirFlowSetpoint(numOfZon=numOfZon)
    annotation (Placement(transformation(extent={{-14,-12},{28,30}})));
  CDL.Continuous.Constant numOfOccupant[numOfZon](k=fill(2, numOfZon))
    "Number of occupant detected in each zone"
    annotation (Placement(transformation(extent={{-90,70},{-80,80}})));
  CDL.Logical.Constant con[numOfZon](k={true,true,true,true,true})
    annotation (Placement(transformation(extent={{-90,46},{-80,56}})));
  CDL.Continuous.Constant cooCtrl(k=0.5) "Cooling control signal"
    annotation (Placement(transformation(extent={{-90,20},{-80,30}})));
  CDL.Logical.Constant winSta[numOfZon](k={false,false,false,false,false})
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-90,-2},{-80,8}})));
  CDL.Logical.Constant supFan(k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-90,-26},{-80,-16}})));
  CDL.Continuous.Constant zonPriFloRat[numOfZon](k={0.1,0.12,0.2,0.09,0.1})
    "Detected primary flow rate in each zone"
    annotation (Placement(transformation(extent={{-90,-52},{-80,-42}})));
equation
  for i in 1:numOfZon loop
    connect(numOfOccupant[i].y, outdoorAirFlowSetpoint.occCou[i]) annotation (
        Line(points={{-79.5,75},{-30,75},{-30,23.91},{-15.89,23.91}}, color={0,0,
            127}));
    connect(con[i].y, outdoorAirFlowSetpoint.uOccDec[i]) annotation (Line(
          points={{-79.5,51},{-34,51},{-34,18.03},{-15.89,18.03}}, color={255,0,
            255}));
    connect(cooCtrl.y, outdoorAirFlowSetpoint.uCoo) annotation (Line(points={{-79.5,
            25},{-38,25},{-38,11.73},{-15.89,11.73}}, color={0,0,127}));
    connect(winSta[i].y, outdoorAirFlowSetpoint.uWindow[i]) annotation (Line(
          points={{-79.5,3},{-51.75,3},{-51.75,5.85},{-15.89,5.85}}, color={255,
            0,255}));
    connect(supFan.y, outdoorAirFlowSetpoint.uSupFan) annotation (Line(points={{
            -79.5,-21},{-34,-21},{-34,-0.45},{-15.89,-0.45}}, color={255,0,255}));
    connect(zonPriFloRat[i].y, outdoorAirFlowSetpoint.priAirflow[i])
      annotation (Line(points={{-79.5,-47},{-30,-47},{-30,-5.91},{-15.89,-5.91}},
          color={0,0,127}));
  end for;


   annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OutdoorAirFlowSetpoint;
