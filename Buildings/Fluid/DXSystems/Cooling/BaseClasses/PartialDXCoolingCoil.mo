within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
partial model PartialDXCoolingCoil
  "Partial model for DX cooling coil"
  extends Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialDXCoil(
    redeclare Buildings.Fluid.DXSystems.Cooling.BaseClasses.DXCooling
      dxCoi(redeclare final package Medium = Medium,
      redeclare Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi),
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(
      prescribedHeatFlowRate=true),
    redeclare Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCoi);

  Modelica.Blocks.Interfaces.RealOutput QLat_flow(
    final quantity="Power",
    final unit="W")
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
      iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Fluid.DXSystems.Cooling.BaseClasses.Evaporation watVapEva(
    redeclare final package Medium = Medium,
    nomVal=datCoi.sta[nSta].nomVal,
    final computeReevaporation=computeReevaporation)
    "Model that computes evaporation of water that accumulated on the coil surface"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));

protected
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.InputPower pwr
    "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  Modelica.Blocks.Sources.RealExpression X(
    final y=XIn[i_x])
    "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-56,24},{-36,44}})));

  Modelica.Blocks.Sources.RealExpression h(
    final y=hIn)
    "Inlet air specific enthalpy"
    annotation (Placement(transformation(extent={{-56,10},{-36,30}})));

  Modelica.Blocks.Sources.RealExpression p(
    final y=port_a.p)
    "Inlet air pressure"
    annotation (Placement(transformation(extent={{-90,2},{-70,22}})));

equation
  connect(p.y,dxCoi.p)  annotation (Line(points={{-69,12},{-58,12},{-58,49.6},{
          -21,49.6}}, color={0,0,127}));
  connect(dxCoi.SHR, pwr.SHR) annotation (Line(points={{1,52},{12,52},{12,64},{18,
          64}},    color={0,0,127}));
  connect(dxCoi.mWat_flow, watVapEva.mWat_flow) annotation (Line(
      points={{1,44},{8,44},{8,8},{-22,8},{-22,-62},{-12,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.QLat_flow, QLat_flow) annotation (Line(points={{41,64},{80,64},{80,
          50},{110,50}}, color={0,0,127}));
  connect(X.y,dxCoi.XEvaIn)  annotation (Line(points={{-35,34},{-32,34},{-32,47},
          {-21,47}}, color={0,0,127}));
  connect(h.y,dxCoi.hEvaIn)  annotation (Line(points={{-35,20},{-28,20},{-28,
          44.3},{-21,44.3}}, color={0,0,127}));
  connect(T.y,dxCoi.TEvaIn)  annotation (Line(points={{-69,28},{-62,28},{-62,52},
          {-21,52}}, color={0,0,127}));
  connect(vol.X_w, watVapEva.XEvaOut) annotation (Line(
      points={{13,-6},{40,-6},{40,-80},{-6,-80},{-6,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut,dxCoi.TConIn)  annotation (Line(points={{-110,30},{-92,30},{-92,
          57},{-21,57}}, color={0,0,127}));
  connect(watVapEva.mTotWat_flow, vol.mWat_flow) annotation (Line(points={{11,-62},
          {22,-62},{22,-42},{-20,-42},{-20,-18},{-11,-18}}, color={0,0,127}));
  connect(pwr.P, P) annotation (Line(points={{41,76},{74,76},{74,90},{110,90}},
        color={0,0,127}));
  connect(pwr.QSen_flow, QSen_flow) annotation (Line(points={{41,70},{110,70}},
                            color={0,0,127}));
  connect(dxCoi.Q_flow, q.Q_flow) annotation (Line(points={{1,56},{22,56},{22,
          54},{42,54}}, color={0,0,127}));
  connect(T.y, watVapEva.TEvaOut) annotation (Line(points={{-69,28},{-64,28},{
          -64,-88},{6,-88},{6,-74}},
                                 color={0,0,127}));
  connect(m.y, watVapEva.mAir_flow) annotation (Line(points={{-69,44},{-66,44},
          {-66,-68},{-12,-68}}, color={0,0,127}));
  connect(dxCoi.EIR, pwr.EIR) annotation (Line(points={{1,60},{6,60},{6,76.6},{18,
          76.6}}, color={0,0,127}));
  connect(dxCoi.Q_flow, pwr.Q_flow) annotation (Line(points={{1,56},{10,56},{10,
          70},{18,70}}, color={0,0,127}));
  annotation (
defaultComponentName="dxCoi",
Documentation(info="<html>
<p>
This partial model is the base class for
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed</a>,
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage\">
Buildings.Fluid.DXSystems.Cooling.AirSource.MultiStage</a> and
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed\">
Buildings.Fluid.DXSystems.Cooling.AirSource.VariableSpeed</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={             Text(
          extent={{58,98},{102,78}},
          textColor={0,0,127},
          textString="P"),      Text(
          extent={{54,80},{98,60}},
          textColor={0,0,127},
          textString="QSen"),   Text(
          extent={{56,62},{100,42}},
          textColor={0,0,127},
          textString="QLat")}));
end PartialDXCoolingCoil;
