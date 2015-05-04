within Buildings.Utilities.Comfort.Examples;
model Fanger "Test of Comfort Model"
  extends Modelica.Icons.Example;

  Buildings.Utilities.Comfort.Fanger theCom(
    use_vAir_in=true,
    use_M_in=true,
    use_pAir_in=true) "Thermal comfort model"
                                            annotation (
      Placement(transformation(extent={{70,-40},{90,-20}})));
  Modelica.Blocks.Sources.Constant ICl(k=0.9) "Clothing insulation"
    annotation (Placement(transformation(extent=[-14,-90; 6,-70])));
  Modelica.Blocks.Sources.Constant vAir(k=0.05) "Air velocity"
    annotation (Placement(transformation(extent=[-80,-56; -60,-36])));
  Modelica.Blocks.Sources.Constant M(k=60) "Metabolic heat generated"
    annotation (Placement(transformation(extent=[-80,-86; -60,-66])));
  Modelica.Blocks.Sources.Ramp TAir(
    duration=1,
    height=10,
    offset=273.15 + 20) "Air temperature"
                        annotation (Placement(
        transformation(extent={{-80,50},{-60,70}})));
  Modelica.Blocks.Sources.Constant TRad(k=273.15 + 22) "Radiation temperature"
    annotation (Placement(transformation(extent=[-80,-26; -60,-6])));
  Modelica.Blocks.Sources.Constant pAtm(k=101325)
    annotation (Placement(transformation(extent=[0,68; 20,88])));
  Modelica.Blocks.Sources.Constant phi(k=0.5) "Relative humidity"
    annotation (Placement(transformation(extent={{-20,
            30},{0,50}})));
  Buildings.Utilities.Comfort.Fanger theComFixPar(
    use_vAir_in=false,
    use_M_in=false,
    use_ICl_in=false,
    use_pAir_in=false,
    ICl=0.9) "Thermal comfort model with fixed parameters"
                                            annotation (
      Placement(transformation(extent={{70,-6},{90,14}})));
equation
  connect(pAtm.y, theCom.pAir_in) annotation (Line(
      points={{21,78},{30,78},{30,-40},{69,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRad.y, theCom.TRad) annotation (Line(
      points={{-59,-16},{8,-16},{8,-24},{69,-24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCom.TAir, TAir.y) annotation (Line(
      points={{69,-20},{-40,-20},{-40,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theCom.vAir_in, vAir.y) annotation (Line(
      points={{69,-31},{-28,-31},{-28,-46},{-59,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(M.y, theCom.M_in) annotation (Line(
      points={{-59,-76},{-20,-76},{-20,-34},{69,-34}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ICl.y, theCom.ICl_in) annotation (Line(
      points={{7,-80},{20,-80},{20,-37},{69,-37}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phi.y, theCom.phi) annotation (Line(
      points={{1,40},{60,40},{60,-28},{69,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRad.y, theComFixPar.TRad)
                               annotation (Line(
      points={{-59,-16},{8,-16},{8,10},{69,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(theComFixPar.TAir, TAir.y)
                               annotation (Line(
      points={{69,14},{-40,14},{-40,60},{-59,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(phi.y, theComFixPar.phi)
                              annotation (Line(
      points={{1,40},{60,40},{60,6},{69,6}},
      color={0,0,127},
      smooth=Smooth.None));
 annotation (experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Comfort/Examples/Fanger.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This is a test of the Thermal Comfort Model.
</html>"));
end Fanger;
