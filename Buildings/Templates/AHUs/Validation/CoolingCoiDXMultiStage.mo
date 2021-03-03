within Buildings.Experimental.Templates.AHUs.Validation;
model CoolingCoiDXMultiStage
  extends BaseNoEquipment(
                      ahu(redeclare record RecordCoiCoo =
          Coils.Data.DXMultiStage (redeclare
            Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.DoubleSpeed.Lennox_KCA120S4
            datCoi), redeclare Coils.DXMultiStage coiCoo));

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
equation
  connect(weaDat.weaBus, ahu.weaBus) annotation (Line(
      points={{-60,60},{0,60},{0,20}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(Tolerance=1e-6, StopTime=1));
end CoolingCoiDXMultiStage;
