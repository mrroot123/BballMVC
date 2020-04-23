using System;

using System.Web.Mvc;
using Unity;
using Unity.Mvc5;

using BballMVC.DTOs;
using BballMVC.IDTOs;

using Bball.BAL;
using Bball.IBAL;


namespace Bball.Unity
{
   /// <summary>
   /// Specifies the Unity configuration for the main container.
   /// </summary>
   public static class UnityConfig
   {
      #region Unity Container
      private static Lazy<IUnityContainer> container =
         new Lazy<IUnityContainer>(() =>
         {
            var container = new UnityContainer();
            RegisterTypes(container);
            return container;
         });

      /// <summary>
      /// Configured Unity Container.
      /// </summary>
      /// 
          public static IUnityContainer Container => container.Value;

      #endregion

      /// <summary>
      /// Registers the type mappings with the Unity container.
      /// </summary>
      /// <param name="container">The unity container to configure.</param>
      /// <remarks>
      /// There is no need to register concrete types such as controllers or
      /// API controllers (unless you want to change the defaults), as Unity
      /// allows resolving a concrete type even if it was not previously
      /// registered.
      /// </remarks>
      /// <summary>
      /// Registers the type mappings with the Unity container.
      /// </summary>
      /// <param name="container">The unity container to configure.</param>
      /// <remarks>
      /// There is no need to register concrete types such as controllers or
      /// API controllers (unless you want to change the defaults), as Unity
      /// allows resolving a concrete type even if it was not previously
      /// registered.
      /// </remarks>
      public static void RegisterTypes(IUnityContainer container)
      {
         // NOTE: To load from web.config uncomment the line below.
         // Make sure to add a Unity.Configuration to the using statements.
         // container.LoadConfiguration();

         // TODO: Register your type's mappings here.
         // it is NOT necessary to register your controllers
         container.RegisterType<IAdjustmentDTO, IAdjustmentDTO>(); // Interface, class
         container.RegisterType<IAdjustmentsBO, AdjustmentsBO>(); // Interface, class

      }

      public static void RegisterTypes()
      {
         // NOTE: To load from web.config uncomment the line below.
         // Make sure to add a Unity.Configuration to the using statements.
         // container.LoadConfiguration();

         // TODO: Register your type's mappings here.
         // container.RegisterType<Interface, class>();

         UnityContainer container = new UnityContainer();

         // register all your components with the container here
         // it is NOT necessary to register your controllers
         container.RegisterType<IAdjustmentDTO, IAdjustmentDTO>(); // Interface, class
         container.RegisterType<IAdjustmentsBO, AdjustmentsBO>(); // Interface, class

         // <System.Web.Mvc>                   <Unity.Mvc5>
         System.Web.Mvc.DependencyResolver.SetResolver(new UnityDependencyResolver(container));
      }

   }
}
