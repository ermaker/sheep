#include "ruby.h"
#include "clipper.hpp"
#include <queue>
#include <iostream>

#define MIN(x,y) ((x)<(y)?(x):(y))
#define MAX(x,y) ((x)<(y)?(y):(x))

using namespace clipper;

static VALUE mKdtree;

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

  VALUE cNode = rb_const_get(mKdtree, rb_intern("Node"));
  VALUE cLeafNode = rb_const_get(mKdtree, rb_intern("LeafNode"));

  unsigned long long result = 0;
  std::queue<VALUE> q;

  q.push(kdtree);

  while(!q.empty())
  {
    VALUE now = q.front();
    q.pop();

    // now.mbr
    double mbr_[4];
    VALUE mbr = rb_iv_get(now, "@mbr");
    VALUE *mbr_ptr = RARRAY_PTR(mbr);
    mbr_[0] = NUM2DBL(mbr_ptr[0]);
    mbr_[1] = NUM2DBL(mbr_ptr[1]);
    mbr_[2] = NUM2DBL(mbr_ptr[2]);
    mbr_[3] = NUM2DBL(mbr_ptr[3]);

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

      // now.object
      VALUE object = rb_iv_get(now, "@object");
      VALUE *object_ptr = RARRAY_PTR(object);
      long object_len = RARRAY_LEN(object);

      // clipper.add_subject_polygon
      TPolygon polygon;
      for(long i=0; i<object_len;i++)
      {
        VALUE *point = RARRAY_PTR(object_ptr[i]);
        polygon.push_back(DoublePoint(NUM2DBL(point[0]),NUM2DBL(point[1])));
      }
      clipper.AddPolygon(polygon, ptSubject);

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

extern "C" {
  void Init_kdtree_query_c()
  {
    mKdtree = rb_define_module("Kdtree");
    VALUE cFactory = rb_define_class_under(mKdtree, "Factory", rb_cObject);
    rb_define_singleton_method(cFactory, "query_c",
        (VALUE(*)(ANYARGS))rb_kdtree_query_c, 5);
  }
}
