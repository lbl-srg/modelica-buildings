within Buildings.Fluid.ZoneEquipment.BaseClasses;
package Validation "Validation models for PTHP control modules"

  extends Modelica.Icons.ExamplesPackage;

  model ModularController
    "Validation model for controller with constant speed fan and DX coils"
    extends Modelica.Icons.Example;

    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
      final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp,
      final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
      final has_fanOpeMod=true,
      final tFanEna=0,
      final dTHys=0.2)
      "Instance of controller with constant speed fan and DX coils"
      annotation (Placement(transformation(extent={{10,-12},{30,16}})));

  protected
    Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(final delayTime=10)
      "Artificial delay for proven on signal"
      annotation (Placement(transformation(extent={{56,-10},{76,10}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanOpeMod(
      final period=900)
      "Supply fan operating mode signal"
      annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
      final height=10,
      final duration=36000,
      final offset=273.15 + 15) "Measured zone temperature"
      annotation (Placement(transformation(extent={{-80,68},{-60,88}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
      final k=273.15 + 23)
      "Heating setpoint temperature"
      annotation (Placement(transformation(extent={{-40,16},{-20,36}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uAva(
      final period=2700)
      "System availability signal"
      annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooSetPoi(
      final k=273.15 + 24)
      "Cooling setpoint temperature"
      annotation (Placement(transformation(extent={{-40,48},{-20,68}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
      final height=6,
      final duration=3600,
      final offset=273.15 + 35)
      "Measured supply air temperature"
      annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

    Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
      final height=5,
      final duration=36000,
      final offset=273.15 + 0) "Outdoor air temperature"
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  equation
    connect(heaSetPoi.y, modCon.THeaSet) annotation (Line(points={{-18,26},{-10,
            26},{-10,4},{8,4}},
                              color={0,0,127}));
    connect(TZon.y, modCon.TZon) annotation (Line(points={{-58,78},{0,78},{0,
            11.4},{8,11.4}},
                       color={0,0,127}));
    connect(supFanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-18,-50},
            {0,-50},{0,-7.4},{8,-7.4}},  color={255,0,255}));
    connect(uAva.y, modCon.uAva) annotation (Line(points={{-18,-18},{-10,-18},{
            -10,-4},{8,-4}},
                           color={255,0,255}));
    connect(modCon.yFan, truDel.u) annotation (Line(points={{32,-10},{46,-10},{
            46,0},{54,0}},       color={255,0,255}));
    connect(truDel.y, modCon.uFan) annotation (Line(points={{78,0},{84,0},{84,
            30},{4,30},{4,14},{8,14},{8,15}},
                                 color={255,0,255}));
    connect(cooSetPoi.y, modCon.TCooSet) annotation (Line(points={{-18,58},{-6,
            58},{-6,7.8},{8,7.8}},
                                 color={0,0,127}));
    connect(TSup.y, modCon.TSup) annotation (Line(points={{-18,-80},{4,-80},{4,
            -11},{8,-11}},
                      color={0,0,127}));
    connect(TOut.y, modCon.TOut)
      annotation (Line(points={{-58,0},{8,0}}, color={0,0,127}));
    annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>.  
    </p>
</html>",  revisions="<html>
      <ul>
      <li>
      Junke 15, 2023 by Karthik Devaprasad, Xing Lu, and Junke Wang:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
      experiment(Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/ModularController.mos"
          "Simulate and plot"));
  end ModularController;

  model SupplementalHeating
    "Validation model for supplemental heating controller"
    extends Modelica.Icons.Example;

    Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating
      conSupHea(final TLocOut(displayUnit="K") = 271.15)
      "Instance of controller for cycling fan and cyling coil"
      annotation (Placement(transformation(extent={{12,-10},{32,10}})));

  protected
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant uHeaMod(
      final k=true)
      "Heating mode signal"
      annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Pulse uHeaEna(
      final period=7200)
      "heating coil enable signal"
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
      final height=12,
      final duration=36000,
      final offset=273.15 + 15)
      "Measured zone temperature"
      annotation (Placement(transformation(extent={{-40,80},{-20,100}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaSetPoi(
      final k=273.15+ 21)
      "Heating setpoint temperature"
      annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TOut(
      final height=-8,
      final duration=18000,
      final offset=273.15 + 3)
      "Outdoor air temperature"
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  equation
    connect(heaSetPoi.y, conSupHea.TSetHea) annotation (Line(points={{-18,60},{
            -10,60},{-10,8},{10,8}}, color={0,0,127}));
    connect(TZon.y, conSupHea.TZon)
      annotation (Line(points={{-18,90},{0,90},{0,4},{10,4}}, color={0,0,127}));
    connect(TOut.y, conSupHea.TOut) annotation (Line(points={{-18,30},{-14,30},{
            -14,0},{10,0}}, color={0,0,127}));
    connect(uHeaEna.y, conSupHea.uHeaEna) annotation (Line(points={{-18,-10},{-6,
            -10},{-6,-8},{10,-8}}, color={255,0,255}));
    connect(uHeaMod.y, conSupHea.uHeaMod) annotation (Line(points={{-18,-40},{-4,
            -40},{-4,-4},{10,-4}}, color={255,0,255}));
    annotation(Icon(coordinateSystem(preserveAspectRatio=false)),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      Documentation(info="<html>
    <p>
    This simulation model is used to validate 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.SupplementalHeating</a>. 
    </p>
    </html>",  revisions="<html>
      <ul>
      <li>
      April 10, 2023, by Xing Lu and Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"),
      experiment(Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/BaseClasses/Validation/SupplementalHeating.mos"
          "Simulate and Plot"));
  end SupplementalHeating;
  annotation(Documentation(info="<html>
    This package contains validation models for the PTHP control modules.
      </html>"));
end Validation;
