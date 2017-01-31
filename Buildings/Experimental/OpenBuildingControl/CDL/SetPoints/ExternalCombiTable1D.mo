within Buildings.Experimental.OpenBuildingControl.CDL.SetPoints;
class ExternalCombiTable1D "External object of 1-dim. table defined by matrix"
  extends ExternalObject;

  function constructor "Initialize 1-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input String tableName "Table name";
    input String fileName "File name";
    input Real table[:, :];
    input Integer columns[:];
    input Modelica.Blocks.Types.Smoothness smoothness;
    output ExternalCombiTable1D externalCombiTable1D;
  external"C" externalCombiTable1D = ModelicaStandardTables_CombiTable1D_init(
          tableName,
          fileName,
          table,
          size(table, 1),
          size(table, 2),
          columns,
          size(columns, 1),
          smoothness) annotation (Library={"ModelicaStandardTables"});
  end constructor;

  function destructor "Terminate 1-dim. table defined by matrix"
    extends Modelica.Icons.Function;
    input ExternalCombiTable1D externalCombiTable1D;
  external"C" ModelicaStandardTables_CombiTable1D_close(externalCombiTable1D)
      annotation (Library={"ModelicaStandardTables"});
  end destructor;

end ExternalCombiTable1D;
