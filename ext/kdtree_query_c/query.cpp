#include "ruby.h"
#include "clipper.hpp"
#include <queue>
#include <iostream>

#define MIN(x,y) ((x)<(y)?(x):(y))
#define MAX(x,y) ((x)<(y)?(y):(x))

using namespace clipper;

static VALUE mKdtree;
static VALUE cNode;
static VALUE cLeafNode;
static VALUE cObjectC;
static VALUE cMBRC;

static VALUE rb_kdtree_query_c(VALUE self, VALUE kdtree,
    VALUE minx_, VALUE miny_, VALUE maxx_, VALUE maxy_)
{
  // arguments
  double minx = NUM2DBL(minx_);
  double miny = NUM2DBL(miny_);
  double maxx = NUM2DBL(maxx_);
  double maxy = NUM2DBL(maxy_);


  // define clip_polygon
  TPolygon clip_polygon;
  clip_polygon.push_back(DoublePoint(minx,miny));
  clip_polygon.push_back(DoublePoint(maxx,miny));
  clip_polygon.push_back(DoublePoint(maxx,maxy));
  clip_polygon.push_back(DoublePoint(minx,maxy));

  // clipper = Clipper.new
  Clipper clipper;

  unsigned long long result = 0;
  std::queue<VALUE> q;

  q.push(kdtree);

  while(!q.empty())
  {
    VALUE now = q.front();
    q.pop();

    // now.mbr_c
    double* mbr_;
    Data_Get_Struct(rb_iv_get(now, "@mbr_c"), double, mbr_);

    // cut
    if(!(MAX(mbr_[0],minx) <= MIN(mbr_[2],maxx) &&
        MAX(mbr_[1],miny) <= MIN(mbr_[3],maxy)))
      continue;

    VALUE now_class = CLASS_OF(now);

    if(now_class == cNode)
    {
      // now.nodes
      VALUE nodes = rb_iv_get(now, "@nodes");
      VALUE *nodes_ptr = RARRAY_PTR(nodes);
      long nodes_len = RARRAY_LEN(nodes);

      for( long i=0; i<nodes_len; i++)
        q.push(nodes_ptr[i]);

    } else if(now_class == cLeafNode)
    {
      // clipper.clear!
      clipper.Clear();

      // now.object_c
      TPolygon* polygon;
      Data_Get_Struct(rb_iv_get(now, "@object_c"), TPolygon, polygon);

      // clipper.add_subject_polygon
      clipper.AddPolygon(*polygon, ptSubject);

      // clipper.add_clip_polygon
      clipper.AddPolygon(clip_polygon, ptClip);

      // clipper.intersection
      TPolyPolygon solution;
      clipper.Execute(ctIntersection, solution, pftEvenOdd, pftEvenOdd);

      if(!solution.empty())
        result += 1;

    } else
    {
    }

  }

  return ULL2NUM(result);
}

static void rb_kdtree_object_c_destory(void* polygon)
{
  delete (TPolygon*)polygon;
}

static VALUE rb_kdtree_leaf_node_object_c(VALUE self)
{
  VALUE object = rb_iv_get(self, "@object");
  VALUE *object_ptr = RARRAY_PTR(object);
  long object_len = RARRAY_LEN(object);

  TPolygon* polygon = new TPolygon;
  for(long i=0; i<object_len;i++)
  {
    VALUE *point = RARRAY_PTR(object_ptr[i]);
    polygon->push_back(DoublePoint(NUM2DBL(point[0]),NUM2DBL(point[1])));
  }

  VALUE object_c = Data_Wrap_Struct(cObjectC, 0,
      rb_kdtree_object_c_destory, polygon);
  rb_obj_call_init(object_c, 0, 0);

  rb_iv_set(self, "@object_c", object_c);

  return Qnil;
}

static void rb_kdtree_node_or_leaf_node_mbr_c_destory(void* mbr)
{
  delete[] (double*)mbr;
}

static VALUE rb_kdtree_node_or_leaf_node_calculate_mbr_c(VALUE self)
{
  double* mbr_ = new double[4];
  VALUE mbr = rb_iv_get(self, "@mbr");
  VALUE *mbr_ptr = RARRAY_PTR(mbr);
  mbr_[0] = NUM2DBL(mbr_ptr[0]);
  mbr_[1] = NUM2DBL(mbr_ptr[1]);
  mbr_[2] = NUM2DBL(mbr_ptr[2]);
  mbr_[3] = NUM2DBL(mbr_ptr[3]);

  VALUE mbr_c = Data_Wrap_Struct(cMBRC, 0,
      rb_kdtree_node_or_leaf_node_mbr_c_destory, mbr_);
  rb_obj_call_init(mbr_c, 0, 0);

  rb_iv_set(self, "@mbr_c", mbr_c);

  return Qnil;
}

extern "C" {
  void Init_kdtree_query_c()
  {
    mKdtree = rb_define_module("Kdtree");
    VALUE cFactory = rb_define_class_under(mKdtree, "Factory", rb_cObject);
    rb_define_singleton_method(cFactory, "query_c",
        (VALUE(*)(ANYARGS))rb_kdtree_query_c, 5);

    cNode = rb_define_class_under(mKdtree, "Node", rb_cObject);
    cLeafNode = rb_define_class_under(mKdtree, "LeafNode", rb_cObject);

    rb_define_method(cLeafNode, "calculate_object_c",
        (VALUE(*)(ANYARGS))rb_kdtree_leaf_node_object_c, 0);

    cObjectC = rb_define_class_under(mKdtree, "ObjectC", rb_cObject);

    rb_define_method(cNode, "calculate_mbr_c",
        (VALUE(*)(ANYARGS))rb_kdtree_node_or_leaf_node_calculate_mbr_c, 0);
    rb_define_method(cLeafNode, "calculate_mbr_c",
        (VALUE(*)(ANYARGS))rb_kdtree_node_or_leaf_node_calculate_mbr_c, 0);

    cMBRC = rb_define_class_under(mKdtree, "MBRC", rb_cObject);
  }
}
