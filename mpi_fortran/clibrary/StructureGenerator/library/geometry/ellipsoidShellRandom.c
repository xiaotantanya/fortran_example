#include <nstructuregenerator/structures.h>

int ellipsoid_shell_random_iter_max = 1000;

NEllipsoidShellPtr n_NEllipsoidShell_random_init(BoxPtr box, BoxPtr radiusBox,
                                               BoxPtr angleBox, double thickMin,
                                               double thickMax) {

  double X = n_random_in_range(box->xmin, box->xmax);
  double Y = n_random_in_range(box->ymin, box->ymax);
  double Z = n_random_in_range(box->zmin, box->zmax);
  NPointPtr centerOuter = n_NPoint_init(X, Y, Z);
  NPointPtr centerInner = n_NPoint_init(X, Y, Z);

  double radiusX = n_random_in_range(radiusBox->xmin, radiusBox->xmax);
  double radiusY = n_random_in_range(radiusBox->ymin, radiusBox->ymax);
  double radiusZ = n_random_in_range(radiusBox->zmin, radiusBox->zmax);

  double thickness = n_random_in_range(thickMin, thickMax);

  double angleX = n_random_in_range(angleBox->xmin, angleBox->xmax);
  double angleY = n_random_in_range(angleBox->ymin, angleBox->ymax);
  double angleZ = n_random_in_range(angleBox->zmin, angleBox->zmax);

  NEllipsoidPtr outer = n_NEllipsoid_init(centerOuter, radiusX, radiusY, radiusZ,
                                        angleX, angleY, angleZ);
  radiusX = radiusX - thickness;
  radiusY = radiusY - thickness;
  radiusZ = radiusZ - thickness;
  NEllipsoidPtr inner = n_NEllipsoid_init(centerInner, radiusX, radiusY, radiusZ,
                                        angleX, angleY, angleZ);

  return n_NEllipsoidShell_init(outer, inner);
}

int n_generate_NEllipsoidShell_random_from_file(int nx, int ny, int nz,
                                                short dat[nx][ny][nz],
                                                const char *fileName,
                                                const char *xpath2geometry) {
  char geometry[MAX_STRING] = {'\0'};
  char xpathText[MAX_STRING] = {'\0'};
  ControlFilePtr cf = n_ControlFile_init(fileName, NULL);
  int count = 0;
  int label = 0, innerLabel = 0;
  int flag = 0;
  int success_count = 0;
  int iter_count = 0;
  n_string_join(xpathText, xpath2geometry, "/type", "");
  n_ControlFile_get_text_by_xpath(geometry, cf->doc, xpathText, "");
  if (strcmp(geometry, "ellipsoid_shell_random") != 0) {
    ZF_LOGE("The geometry %s %s is not a random ellipsoid shell", fileName,
            xpath2geometry);
  } else {
    ZF_LOGI("Random ellipsoid shell");
  }

  n_string_join(xpathText, xpath2geometry, "/label", "");
  label = n_ControlFile_get_int_by_xpath(cf->doc, xpathText, "", 1);

  n_string_join(xpathText, xpath2geometry, "/labelInner", "");
  innerLabel = n_ControlFile_get_int_by_xpath(cf->doc, xpathText, "", 1);

  n_string_join(xpathText, xpath2geometry, "/count", "");
  count = n_ControlFile_get_int_by_xpath(cf->doc, xpathText, "", 1);

  double centerXMin, centerYMin, centerZMin;
  double centerXMax, centerYMax, centerZMax;
  double radiusXMin, radiusYMin, radiusZMin;
  double radiusXMax, radiusYMax, radiusZMax;
  double rotationXMin, rotationYMin, rotationZMin;
  double rotationXMax, rotationYMax, rotationZMax;
  double thickMin, thickMax;

  n_string_join(xpathText, xpath2geometry, "/centerXMin", "");
  centerXMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/centerXMax", "");
  centerXMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/centerYMin", "");
  centerYMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/centerYMax", "");
  centerYMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/centerZMin", "");
  centerZMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/centerZMax", "");
  centerZMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  BoxPtr centerBox = n_Box_init(centerXMin, centerXMax, centerYMin, centerYMax,
                                centerZMin, centerZMax);

  n_string_join(xpathText, xpath2geometry, "/radiusXMin", "");
  radiusXMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/radiusXMax", "");
  radiusXMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/radiusYMin", "");
  radiusYMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/radiusYMax", "");
  radiusYMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/radiusZMin", "");
  radiusZMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  n_string_join(xpathText, xpath2geometry, "/radiusZMax", "");
  radiusZMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 1);
  BoxPtr radiusBox = n_Box_init(radiusXMin, radiusXMax, radiusYMin, radiusYMax,
                                radiusZMin, radiusZMax);

  n_string_join(xpathText, xpath2geometry, "/rotationXMin", "");
  rotationXMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/rotationXMax", "");
  rotationXMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/rotationYMin", "");
  rotationYMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/rotationYMax", "");
  rotationYMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/rotationZMin", "");
  rotationZMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/rotationZMax", "");
  rotationZMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  BoxPtr rotationBox = n_Box_init(rotationXMin, rotationXMax, rotationYMin,
                                  rotationYMax, rotationZMin, rotationZMax);

  n_string_join(xpathText, xpath2geometry, "/thickMin", "");
  thickMin = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);
  n_string_join(xpathText, xpath2geometry, "/thickMax", "");
  thickMax = n_ControlFile_get_double_by_xpath(cf->doc, xpathText, "", 0);

  int matrixLabel,matrixLabelGlobal;
  n_string_join(xpathText, xpath2geometry, "/matrixLabel", "");
  matrixLabelGlobal = n_ControlFile_get_int_by_xpath(cf->doc, "/input/structure/matrixLabel", "", 0);
  matrixLabel = n_ControlFile_get_int_by_xpath(cf->doc, xpathText, "", matrixLabelGlobal);

  n_ControlFile_free(cf);

  int rc = 0;
  char temp[32];
  xmlTextWriterPtr writer;
  n_string_concat(xpathText, 2, "/", MY_STRUCTURE_FILE_ROOT);
  ControlFilePtr cfout =
      n_ControlFile_init(MY_STRUCTURE_FILE, MY_STRUCTURE_FILE_ROOT);
  //   xmlNodePtr node = n_ControlFile_get_nth_nodeset_by_xpath(cfout->doc,
  //   xpathText, 0);
  writer = xmlNewTextWriterTree(cfout->doc, cfout->root, 0);
  rc = xmlTextWriterStartElement(writer, BAD_CAST "geometry");
  rc = xmlTextWriterStartElement(writer, BAD_CAST "type");
  sprintf(temp, "%s", "ellipsoid_shell_random");
  rc = xmlTextWriterWriteString(writer, BAD_CAST temp);
  rc = xmlTextWriterEndElement(writer); // For type

  int volume_count = 0;
  do {
    NEllipsoidShellPtr ellipsoidShell = n_NEllipsoidShell_random_init(
        centerBox, radiusBox, rotationBox, thickMin, thickMax);
    flag = n_NEllipsoidShell_insert(nx, ny, nz, dat, ellipsoidShell, label,
                                   innerLabel, matrixLabel);
    if (flag == -1) {
      // insert ellipsoid not successful
      iter_count = iter_count + 1;
      ZF_LOGI("missed an ellipsoid shell");

    } else {
      // insert ellipsoid successful
      // ZF_LOGD("Create an ellipsoid %f %f
      // %f",ellipsoid->center->x,ellipsoid->center->y,ellipsoid->center->z);
      n_NEllipsoidShell_print(ellipsoidShell, "");
      n_NEllipsoidShell_print_xml_by_writer(ellipsoidShell, writer,
                                           "ellipsoid_shell");
      volume_count = volume_count + ellipsoidShell->count;
      success_count = success_count + 1;
      iter_count = 0;
    }
    n_NEllipsoidShell_free(ellipsoidShell);
  } while (success_count < count &&
           iter_count < ellipsoid_shell_random_iter_max);

  rc = xmlTextWriterStartElement(writer, BAD_CAST "count");
  sprintf(temp, "%i", volume_count);
  rc = xmlTextWriterWriteString(writer, BAD_CAST temp);
  rc = xmlTextWriterEndElement(writer); // For count

  rc = xmlTextWriterEndElement(writer); // For geometry
  xmlFreeTextWriter(writer);
  xmlSaveFileEnc(MY_STRUCTURE_FILE, cfout->doc, MY_STRUCTURE_ENCODING);
  n_ControlFile_free(cfout);
  n_Box_free(centerBox);
  n_Box_free(radiusBox);
  n_Box_free(rotationBox);
  return volume_count;
}