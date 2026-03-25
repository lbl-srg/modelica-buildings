within Buildings.Controls.OBC.DemandFlexibility.ChillerSetpointControl;
block SingleChiller

   parameter Real delChaShe=1
    "Change amount for load shed";

   parameter Real delChaReb=-1
    "Change amount for rebound";

    parameter Real uCooCoiValTho(min=0)=0.95
    "Cooling coil valve threshold below which ratcheting is triggerd.";

            parameter Real samPerNom(unit="s")=300
    "Sample period for the nominal condition";
        parameter Real samPerShe(unit="s")=300
    "Sample period for ratchet";
        parameter Real samPerReb(unit="s")=300
    "Sample period for rebound";
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-190,24},{-150,64}}),
        iconTransformation(extent={{-190,24},{-150,64}})));
  CDL.Interfaces.RealOutput TSetCom "setpoint command"
    annotation (Placement(transformation(extent={{250,-90},{290,-50}}),
        iconTransformation(extent={{250,-90},{290,-50}})));
  CDL.Interfaces.RealInput TSetNom "nominal setpoint"
    annotation (Placement(transformation(extent={{-192,-204},{-152,-164}})));
  CDL.Interfaces.RealInput TSetCur "current setpoint"
    annotation (Placement(transformation(extent={{-190,-54},{-150,-14}})));
  CDL.Interfaces.RealInput TSetTarShe "setpoint target for load shed"
    annotation (Placement(transformation(extent={{-192,-156},{-152,-116}}),
        iconTransformation(extent={{-192,-156},{-152,-116}})));
  CDL.Interfaces.RealInput uCooCoiValCur "current cooling coil valve signal"
    annotation (Placement(transformation(extent={{-190,-12},{-150,28}})));
  Subsequences.SingleChillerBase singleChillerSetpointControlBase(
    delChaShe=delChaShe,
    delChaReb=delChaReb,
    uCooCoiValTho=uCooCoiValTho,
    samPerNom=samPerNom,
    samPerShe=samPerShe,
    samPerReb=samPerReb)
    annotation (Placement(transformation(extent={{-40,-120},{160,32}})));
  CDL.Logical.Sources.Constant con1(k=true)
    annotation (Placement(transformation(extent={{-92,78},{-72,98}})));
equation
  connect(singleChillerSetpointControlBase.TSetCom, TSetCom) annotation (Line(
        points={{170,-58.25},{211,-58.25},{211,-70},{270,-70}}, color={0,0,127}));
  connect(uCooCoiValCur, singleChillerSetpointControlBase.uCooCoiValCur)
    annotation (Line(points={{-170,8},{-108,8},{-108,-21.2},{-50,-21.2}}, color
        ={0,0,127}));
  connect(TSetCur, singleChillerSetpointControlBase.TSetCur) annotation (Line(
        points={{-170,-34},{-108,-34},{-108,-41.15},{-50,-41.15}}, color={0,0,
          127}));
  connect(TSetTarShe, singleChillerSetpointControlBase.TSetTarShe) annotation (
      Line(points={{-172,-136},{-110,-136},{-110,-89.6},{-51,-89.6}}, color={0,
          0,127}));
  connect(TSetNom, singleChillerSetpointControlBase.TSetNom) annotation (Line(
        points={{-172,-184},{-78,-184},{-78,-112.4},{-51,-112.4}},   color={0,0,
          127}));
  connect(uMod, singleChillerSetpointControlBase.uMod) annotation (Line(points={{-170,44},
          {-80,44},{-80,-4.1},{-50,-4.1}},              color={255,127,0}));
  connect(con1.y, singleChillerSetpointControlBase.have_pri) annotation (Line(
        points={{-70,88},{-62,88},{-62,14},{-50,14},{-50,13}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-150,-200},{250,120}},
        grid={2,2})),
    Documentation(info="<html>
<p>This is a utility block that controls the chiller temperature setpoint for a single chiller, 
based on the current mode uMod:  1 = load shed mode, 2 = load rebound mode, and 0 = baseline 
mode. </p>
</html>"));
end SingleChiller;
