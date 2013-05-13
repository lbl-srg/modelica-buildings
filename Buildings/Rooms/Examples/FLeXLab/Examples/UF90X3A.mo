within Buildings.Rooms.Examples.FLeXLab.Examples;
model UF90X3A "Example for UF90X3A"
  extends Modelica.Icons.Example;

  Cells.UF90X3A UF90X3A(use_AirPor=true, use_airCon_file=false)
    annotation (Placement(transformation(extent={{-22,-18},{18,22}})));
  annotation (Commands(file=
          "Resources/Scripts/Dymola/Rooms/Examples/FLeXLab/Examples/UF90X3A.mos"
        "Simulate and Plot"));
end UF90X3A;
